class Client::RequestsController < ApplicationController
  before_filter :login_required
  #layout "temp"
  uses_tiny_mce
  PER_PAGE = 20
  require_role [Role::CLIENT, Role::MANAGER], :except => [:paginate_changes]

  def index    
    page = (params[:page] || 1).to_i
    selected_project = params[:project_id] || "all"
    priority = params[:priority] || "all"
    if selected_project == "all"
      session[:active_project] = nil
      @client_requests = ClientRequest.paginate_requests(current_account.project_ids, priority, page, PER_PAGE)
    else
      @project = Project.find(selected_project)
      @client_requests = ClientRequest.paginate_requests(selected_project, priority, page, PER_PAGE)
      session[:active_project] = selected_project.to_i
    end
    render :action => :index
  end
  
  def new
    id = params[:id]
    id = session[:active_project] if id.nil?
    @project = Project.find_by_id(id, current_account)    
    unless @project.nil?
      session[:project_id] = @project.id
      @client_request = ClientRequest.new
      # Clear previous warning messages.
      flash[:notice] = nil
    else
      session[:project_id] = nil
      flash[:notice] = "Please select a project"
    end
  end

  # Create a new client_request.
  def create
    @client_request = ClientRequest.new(params[:client_request])
    @client_request.status = "new"
    attachment_saved = save_attached_file(params)    
    client_request_saved = attachment_saved && @client_request.save && @client_request.errors.empty?    
    if client_request_saved
      session[:client_request_id] = @client_request.id
      flash[:info] = "ClientRequest created successfully"
      session[:client_request_id] = @client_request.id
      Task.create(:title => @client_request.title, :client_request => @client_request,
        :project => @client_request.milestone.project, :status => Task::UNASSIGNED)
      redirect_to :controller => :requests, :action => :index,
        :project_id => @client_request.milestone.project.id
    else
      @project = Project.find_by_id(session[:active_project], current_account)
      render :action => "new"
      
    end
  end

  def new_change
    @client_request_change = ClientRequestChange.new(
      :description => params[:description].to_s.gsub('<br mce_bogus="1">', ""),
      :client_request_id => params[:client_request_id])
    readonly = readonly?(current_account)    
    render :update do |page|
      if @client_request_change.save && @client_request_change.errors.empty?
        page.call "ClientRequestChange.afterSave"
        @client_request_changes = ClientRequestChange.paginate_by_client_request(@client_request_change.client_request_id, 1)
        page.replace_html "changeList",
          :partial => "change_list", :locals => {:changes => @client_request_changes, :readonly => readonly}
        page.visual_effect :highlight, "change#{@client_request_change.id}", {:duration => 2}
        page.call "ClientRequestChange.bindCreateChangeBtn"
      else
        page.call "ClientRequestChange.bindCreateChangeBtn()"
        page.replace "newChangeError", (error_messages_for :client_request_change, :id => "newChangeError")
      end
    end
  end

  def delete_change
    change = ClientRequestChange.find_by_id_with_security_check(params[:id], current_account)
    change.destroy()
    rcp = params[:rcp].to_i
    rcp = 1 if rcp <= 0
    @client_request_changes = Array.new
    while @client_request_changes.empty? && rcp > 0 do
      @client_request_changes = ClientRequestChange.paginate_by_client_request(change.client_request_id, rcp)
      rcp = rcp - 1
    end
    render :update do |page|
      page.visual_effect :fade, "change#{params[:id]}", :duration => 2
      page.delay(2) do
        page.replace_html "changeList",
          :partial => "change_list", :locals => {:changes => @client_request_changes, :readonly => false}
        page.call "ClientRequestChange.bindCreateChangeBtn"
      end
    end
  end

  def paginate_changes
    page = params[:rcp] # client_request change page
    client_request_id = params[:rid] # client_request_id
    @client_request_changes = ClientRequestChange.paginate_by_client_request(client_request_id, page)
    readonly = readonly?(current_account)
    render :partial => "change_list",
      :locals => {:changes => @client_request_changes, :readonly => readonly}
  end

  # Update the description of a client_request change. This method is used by in_place_editing plugin.
  def set_change_description
    description = params[:value]
    change = ClientRequestChange.find(params[:id])
    unless description.nil? || description.empty?
      change.description = description
      change.save
    end
    render :text => change.description
  end

  def show
    @client_request = ClientRequest.first( :conditions => { :id => params[:id].to_i})
    @readonly = readonly?(current_account)
    @client_msg = ClientMessage.client_discussion_on_task(@client_request.id, params[:page])
    @client_request_changes = ClientRequestChange.paginate_by_client_request(@client_request.id, nil)
    @attached_files = AttachedFile.paginate_by_client_request(@client_request.id, nil)    
  end

  def update_state_and_priority    
    @client_request = ClientRequest.find(params[:id])        
    @task = @client_request.task
    success = false
    status = params[:client_request][:status]
    if status.eql?("Archived")
      @task.archive
      @client_request.archive
      success = @task.save and @client_request.save
    elsif status.eql?("Unmet")
      @task.reopen
      @client_request.reopen
      Mailer.task_assigned(@task).deliver
      success = @task.save and @client_request.save
    elsif status.eql?("Invalid")
      @task.invalid
      @client_request.invalid
      success = @client_request.save and @task.save
    end
    if success
      redirect_to list_requests_by_project_path(:project_id => @client_request.milestone.project_id)
    else
      flash[:notice] = "Error when updating request"
      render :action =>'show'  
    end
  end

  private
  
  def save_attached_file(params)
    attachment_saved = true # This is to handle no-attachment cases.
    ClientRequest.transaction do
      params[:attach_files].values.each { |item|
        @attached_file = AttachedFile.new(item)
        @attached_file.client_request = @client_request
        attachment_saved = @attached_file.save && @attached_file.errors.empty?
      }
    end unless params[:attach_files].nil?
    return attachment_saved
  end

  def readonly?(current_account)
    readonly = true
    if(current_account.is_a? Client) || current_account.has_role?(Role::MANAGER)
      readonly = false
    end
    readonly
  end
end

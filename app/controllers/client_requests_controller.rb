class ClientRequestsController < ApplicationController
  #  layout "temp"
  uses_tiny_mce
  before_filter :login_required
  require_role [Role::ADMIN, Role::MANAGER, Role::LEAD, Role::WORKER]
  PER_PAGE = 15
  def index
    page = (params[:page] || 1).to_i
    selected_project = params[:project_id] || session[:active_project] || "all"
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
    unless id.nil?
      @project = Project.find_by_id(id, current_account)
      session[:project_id] = @project.id
      @client_request = ClientRequest.new
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
      task = Task.create(:title => @client_request.title, :client_request => @client_request,
        :project => @client_request.milestone.project, :status => Task::UNASSIGNED)
      redirect_to show_estimate_task_path(:id => task.id)
    else      
      @project = Project.find_by_id(session[:active_project], current_account)
      render :action => "new"
    end
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
       @task.save
      success = @client_request.save
    elsif status.eql?("Unmet")
      @task.reopen      
      @client_request.reopen
      Mailer.task_assigned(@task).deliver
      @task.save
      @client_request.update_attributes(:priority => params[:client_request][:priority])
      success = @client_request.save
    elsif status.eql?("Invalid")      
      @task.invalid      
      @client_request.invalid
      @task.save(:validate => false)
      success = @client_request.save
    else
      success = @client_request.update_attributes(:priority => params[:client_request][:priority])
    end    
    if success
      redirect_to manager_list_requests_by_project_path(:project_id => @client_request.milestone.project_id)
    else
      flash[:notice] = "Error when updating request"
      render :action =>'show'
    end
  end
  
  private
  
  def readonly?(current_account)
    readonly = true
    if(current_account.is_a? Client) || current_account.has_role?(Role::MANAGER)
      readonly = false
    end
    readonly
  end

  

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
  
end
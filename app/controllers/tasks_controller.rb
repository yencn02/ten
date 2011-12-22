class TasksController < ApplicationController
  # Authentication & authorization configuration
  before_filter :login_required
  require_role [Role::ADMIN, Role::MANAGER, Role::LEAD, Role::WORKER], :except => [:client_discussion, :save_message_client, :delete_message_client, :set_note_description]
  PER_PAGE = 10
  def edit    
    @task = Task.find_by_id(params[:id], current_account)
    @client_request_changes = ClientRequestChange.paginate_by_client_request(@task.client_request_id, nil)
    @task_files = AttachedFile.paginate_by_task(@task.id, nil)
    @client_request_files = AttachedFile.paginate_by_client_request(@task.client_request_id, nil)
    @technical_notes = TechnicalNote.paginate_by_task(@task.id, nil)
  end

  def assign    
    task_id = params[:task_id]
    worker_id = params[:worker_id] # The worker to whom the task is assigned.
    task = Task.find(task_id)
    task.worker = Worker.find(worker_id)
    task.assign if task.status == Task::UNASSIGNED # Change the status of the task.
    task.client_request.start if task.client_request.status == ClientRequest::NEW
    Mailer.task_assigned(task).deliver
    task.save
    task.client_request.save    
    redirect_to "/tasks/list/#{task.project_id}/all"
  end
  

  def show_task_list
    @worker_id = params[:worker_id]
    # TODO What if worker_id is nil?    
    task_lists = Task.worker_task_list(@worker_id, "assigned")    
    # TODO What if no task is found?
    render :update do |page|
      page.call "switchActiveWorker", "#{@worker_id}"
      page[:tasklist].replace :partial => "assigned_task_list", :locals => {:task_list => task_lists}
    end
  end

  
  def show_estimate
    #prepare data for showing on estimated form    
    @task = Task.find(params[:id])     
  end
  
  def estimate
    #do estimate    
    @task = Task.find(params[:task_id])
    hash = params[:task]    
    if(@task.update_attributes(hash))
      redirect_to assign_task_path(:id => @task.id)
    else      
      flash[:notice] = "Error when saving task"       
      redirect_to show_estimate_task_path(:id => @task.id)
    end
  end
  
  def show_volunteer
    @task = Task.find(params[:id])    
  end

  def volunteer
    @task = Task.find(params[:task_id])
    hash = params[:task] 
    @task.worker = current_account
    @task.assign    
    if(@task.update_attributes(hash))
      request = @task.client_request
      request.start
      request.save
      redirect_to task_path(@task.id)
    else
      flash[:notice] = "Error when saving task" 
      redirect_to :action => :show_volunteer, :id =>@task.id
    end     
  end

  #
  # List out tasks of the specified project
  #
  def list    
    selected_project = session[:active_project]    
    status = params[:status] || session[:active_task_status]    
    if status.eql?("all") and params[:project_id].nil?
      selected_project = params[:project_id]
    end

    if status == "all"
    @task_unassigned = Task.find_by_status("unassigned", selected_project, current_account)
    @task_unassigned = @task_unassigned.sort{|x,y| x.client_request.priority <=> y.client_request.priority }
    if params[:project_id].nil?      
      @task_user_login = Task.all(:conditions => ["worker_id =?", current_account.id], :order => "created_at DESC")
    else
      @task_user_login = Task.all(:order => "created_at DESC", :conditions => ["worker_id =? and project_id =?", current_account.id, params[:project_id]])
    end
    @task_user_login = @task_user_login.sort{|x,y| x.client_request.priority <=> y.client_request.priority }
    @task_other = Task.find_task_other(status, selected_project, current_account)
    @task_other = @task_other.sort{|x,y| x.client_request.priority <=> y.client_request.priority}    
    tasks = []
    tasks = @task_unassigned << @task_user_login << @task_other
    tasks = tasks.flatten
    @tasks = tasks.paginate :page => current_page(), :per_page => PER_PAGE
    elsif status == "unassigned"
      if params[:project_id].nil?
        @tasks = Task.paginate_by_status(status, nil, current_page() , current_account)
      else
        @tasks = Task.paginate_by_status(status, selected_project, current_page() , current_account)
      end
    else
      if params[:project_id].nil?
        @task_user_login = Task.all(:conditions => ["worker_id =? and status =?", current_account.id, status])
        @task_user_login = @task_user_login.sort{|x,y| x.client_request.priority <=> y.client_request.priority }
        @task_other = Task.find_task_other_by_status(status, nil, current_account)
        @task_other = @task_other.sort{|x,y| x.client_request.priority <=> y.client_request.priority}
        tasks = []
        tasks = @task_user_login << @task_other
        tasks = tasks.flatten
        @tasks = tasks.paginate :page => current_page(), :per_page => PER_PAGE
      else
        @task_user_login = Task.all(:conditions => ["worker_id =? and status =? and project_id =? ", current_account.id, status, params[:project_id]])
        @task_user_login = @task_user_login.sort{|x,y| x.client_request.priority <=> y.client_request.priority }
        @task_other = Task.find_task_other_by_status(status, params[:project_id], current_account)
        @task_other = @task_other.sort{|x,y| x.client_request.priority <=> y.client_request.priority}
        tasks = []
        tasks = @task_user_login << @task_other
        tasks = tasks.flatten
        @tasks = tasks.paginate :page => current_page(), :per_page => PER_PAGE
      end
    end
  end


  def assign_task
    # Delete unused session-stored data.
    session[:project_id] = nil
    session[:client_request_id] = nil    
    @task = Task.find(params[:id])    
    @active_worker = Worker.worker_with_least_assigned_hours(@task.project.id)
    @worker_id = @active_worker.id unless @active_worker.nil?
    unless @active_worker.nil?      
      @active_task_list = Task.worker_task_list(@active_worker.id, Task::ASSIGNED)     
      @worker_list = @task.project.worker_group.accounts
    end    
  end

  def show
    @task_id = params[:id]
    @task = Task.find_by_id(@task_id, current_account)
    @client_request_changes = ClientRequestChange.paginate_by_client_request(@task.client_request_id, nil)        
    @dev_msg = Message.developer_discussion_on_task(@task.id, params[:page])
    @client_msg = ClientMessage.client_discussion_on_task(@task.client_request_id, params[:page])    
    @task_files = AttachedFile.paginate_by_task(@task.id, nil)    
    @client_request_files = AttachedFile.paginate_by_client_request(@task.client_request_id, nil)
    @technical_notes = TechnicalNote.paginate_by_task(@task.id, nil)
  end
  
  def save_message_dev
    @message = Message.new(params[:message])
    @message.title = params[:message][:body]
    if @message.save
      render :update do |page|
        page.call "Message.dev_after_save"       
        Message.init_message_status(@message)
        @task = @message.task
        Mailer.task_message(@message).deliver
        @dev_msg = Message.developer_discussion_on_task(@message.task_id, 1)        
        page.replace_html "dev-message-list", :partial => "dev_messages"
        page.visual_effect :highlight, "newdev#{@message.id}", {:duration => 2}
        page.call "Message.toogle_header"
        page.call "Message.reply"
      end
    else
      render :update do |page|
        page.show "#newDevMessageError"
      end
    end    
  end
  
  def delete_message_dev    
    message = Message.find(params[:message_id])
    pa = params[:page].to_i # tnp: technical note page
    pa = 1 if pa <= 0
    @dev_msg = Array.new
    render :update do |page|
      if message.destroy
        while @dev_msg.nil? && pa > 0 do
          @dev_msg = Message.developer_discussion_on_task(message.task_id, pa)
          pa = pa - 1          
        end                
        page.replace_html "dev-message-list", :partial => "dev_messages"
        page.call "Message.toogle_header"
        page.call "Message.reply"
      end      
    end
  end

  def add_note    
    @technical_note = TechnicalNote.new(params[:technical_note])
    render :update do |page|
      if @technical_note.save
        @task_id = @technical_note.task_id
        @technical_notes = TechnicalNote.paginate_by_task(@technical_note.task_id, 1)        
        page.call "AddNote.afterSave"
        page.replace_html "note_list", :partial => "note_list", :locals => {:technical_notes => @technical_notes, :task_id => @task_id}
        page.visual_effect :highlight, "note#{@technical_note.id}", {:duration => 2}
      else
        page.replace "#errorExplanation",
          (error_messages_for :technical_note, :id => "errorExplanation")
      end
    end
  end  
  
  def tech_note_paginate    
    @task_id = params[:id]
    @technical_notes = TechnicalNote.paginate_by_task(params[:id], params[:page])
  end


  def developer_discussion
    @dev_msg = Message.developer_discussion_on_task(params[:id], params[:page])
  end

  def save_message_client    
    @message = ClientMessage.new(params[:client_message])
    @message.title = @message.body    
    render :update do |page|      
      if @message.save && @message.errors.empty?      
        ClientMessage.init_message_status(@message)
        if @current_account.has_role?(Role::MANAGER)
          Mailer.client_request_message(@message).deliver
        elsif @current_account.has_role?(Role::CLIENT)          
          Mailer.send_message_to_manager(@message).deliver
        end
        page.call "Message.client_after_save"
        @client_msg = ClientMessage.client_discussion_on_task(@message.client_request_id, 1)
        page.replace_html "client-message-list", :partial => "client_messages"
        page.visual_effect :highlight, "newclient#{@message.id}", {:duration => 2}
        page.call "Message.toogle_header"
        page.call "Message.reply"
      else       
        page.show "#newClientMessageError"
      end
    end
  end

  def delete_message_client   
    client_message = ClientMessage.find(params[:message_id])
    pa = params[:page].to_i    
    pa = 1 if pa <= 0
    @client_msg = Array.new
    render :update do |page|
      if client_message.destroy
        while @client_msg.empty? && pa > 0 do
           @client_msg = ClientMessage.client_discussion_on_task(client_message.client_request_id, pa)
           pa = pa - 1           
        end
        page.replace_html "client-message-list", :partial => "client_messages"
        page.call "Message.toogle_header"
        page.call "Message.reply"  
      end
    end    
  end

  def client_discussion   
    @client_msg = ClientMessage.client_discussion_on_task(params[:id], params[:page])
  end

  # Delete a technical note
  def delete_note
    note_id = params[:id]
    note = TechnicalNote.find_by_id(note_id)   
    #    if note.allows_update?(current_account)
    note.destroy()
    rcp = params[:page].to_i # tnp: technical note page
    rcp = 1 if rcp <= 0
    @technical_notes = Array.new
    # If there are no items at the current page, go back one page.
    while @technical_notes.empty? && rcp > 0 do 
      @technical_notes = TechnicalNote.paginate_by_task(note.task_id, rcp)
      rcp = rcp - 1
    end
    render :update do |page|
      page.visual_effect :fade, "note#{note_id}", :duration => 2
      page.delay(2) do
        page.replace_html "note_list", :partial => "note_list", :locals => {:technical_notes => @technical_notes, :task_id => note.task_id}
      end
    end
  end

  def set_note_description
    note = TechnicalNote.find(params[:id])
    # Keep the current description if the new description is nil.
    unless params[:value].empty?
      note.description = params[:value]      
      note.save
    end
    render :text => note.description
  end
end

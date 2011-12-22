require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"

describe TasksController, "GET list" do
  before(:each) do
    @account = login_as_worker
    @tasks = [mock_model(Task)]
    session[:active_project] = nil
    #For menu
    Project.should_receive(:paginate_by_activity).with(@account, "active", nil)
  end

#  it "should get tasks of active project from session, if availble" do
#    project = mock_model(Project, :name => "Project 1")
#    Project.stub!(:find).and_return(project)
#    @project_id = project.id
#    session[:active_project] = project.id
#    page = 1
#    Task.stub!(:paginate_by_status).with(Task::OPEN, project.id, page, @account).and_return @tasks
#    get :list, :status => Task::OPEN
#    assigns[:tasks].should == @tasks
#  end
#

  it "should get tasks of active project from session, if availble" do
    @project = mock_model(Project, :name => "Project 1")
    Project.stub!(:most_active).with(@account).and_return @project
    session[:active_project] = @project.id
    page = 1
    Task.stub!(:paginate_by_status).with(Task::OPEN, @project.id, page, @account).and_return @tasks
    get :list, :project_id => @project.id, :status => Task::OPEN
    assigns[:tasks].should == @tasks
  end

  it "should get tasks of all projects if there is no active project" do
    session[:active_project] = nil
    page = 1
    Task.should_receive(:paginate_by_status).with(Task::OPEN, "1", page, @account).and_return @tasks
    get :list, :status => Task::OPEN, :project_id => "1"

  end

  it "should get all tasks if status is not provided" do
    page = 1
    Task.stub!(:paginate_by_status).with("all", nil, page, @account).and_return @tasks
    get :list
  end

  it "should get tasks of all status if status is 'all'" do
    tasks = Array.new(3){mock_model(Task)}
    Task.stub!(:find).and_return tasks
    get :list, :status => Task::ALL
  end
  it "should get tasks of specific status: ASSIGNED" do
    page = 1
    Task.stub!(:paginate_by_status).with(Task::ASSIGNED, nil, page, @account).and_return @tasks
    get :list, :status => Task::ASSIGNED
  end
  it "should get tasks of specific status: COMPLETE" do
    page = 1
    Task.stub!(:paginate_by_status).with(Task::COMPLETE, nil, page, @account).and_return @tasks
    get :list, :status => Task::COMPLETE
  end
  it "should get tasks of specific status: VERIFIED" do
    page = 1
    Task.stub!(:paginate_by_status).with(Task::VERIFIED, nil, page, @account).and_return @tasks
    get :list, :status => Task::VERIFIED
  end
end


describe TasksController, "GET list" do
  before(:each) do
    @account = login_as_manager
    @tasks = [mock_model(Task)]
    session[:active_project] = nil
    #For menu
    Project.should_receive(:paginate_by_activity).with(@account, "active", nil)
  end

  it "should get tasks of all projects if there is no active project" do
    session[:active_project] = nil
    page = 1
    Task.should_receive(:paginate_by_status).with(Task::OPEN, "1", page, @account).and_return @tasks
    get :list, :status => Task::OPEN, :project_id => "1"

  end
end

describe TasksController, "PUT edit" do
  before(:each) do
      @account =  login_as_worker
      controller.stub!(:menu)
      @task = mock_model(Task, :client_request_id => 1)
      Task.should_receive(:find_by_id).with(@task.id.to_s, @account).and_return @task
      @request_files = [mock_model(AttachedFile)]
      AttachedFile.should_receive(:paginate_by_client_request).with(@task.client_request_id, nil).and_return @request_files
      @request_changes = [mock_model(ClientRequestChange)]
      ClientRequestChange.should_receive(:paginate_by_client_request).with(@task.client_request_id, nil).and_return @request_changes
      @task_files = mock("List of task files")
      AttachedFile.should_receive(:paginate_by_task).with(@task.id, nil).and_return @task_files
      @notes = [mock_model(TechnicalNote)]
      TechnicalNote.should_receive(:paginate_by_task).with(@task.id, nil).and_return @notes
  end

  it "should find the task by id" do    
    put :edit, :id => @task.id.to_s
    assigns[:task].should == @task
  end
  it "should get the request attached files" do
    put :edit, :id => @task.id.to_s
    assigns[:client_request_files].should == @request_files
  end
  it "should get the client request changes" do
    put :edit, :id => @task.id.to_s
    assigns[:client_request_changes].should == @request_changes
  end
  it "should get the task attached files" do
    put :edit, :id => @task.id.to_s
    assigns[:task_files].should == @task_files
  end
  it "should get task technical notes" do
    put :edit, :id => @task.id.to_s
    assigns[:technical_notes].should == @notes
  end

end


describe TasksController, "POST assign" do
  before(:each) do
    controller.stub!(:menu)
    @account = login_as_lead
    @project = mock_model(Project)
    @client_request = mock_model(ClientRequest, :start => true, :status => ClientRequest::NEW)
    @task = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::OPEN)
    @worker = mock_model(Worker)
    @task.stub!(:assign).and_return true
    @task.stub!(:save).and_return true
    Task.should_receive(:find).with(@task.id.to_s).and_return @task
    Worker.should_receive(:find).with(@worker.id.to_s).and_return @worker
  end
  it "should assign task to worker" do
    post :assign, :task_id => @task.id.to_s, :worker_id => @worker.id.to_s
    @task.worker.should == @worker
  end
  it "should change task and client request status" do
    @task.should_receive(:assign)
    @client_request.should_receive(:start)
    post :assign, :task_id => @task.id.to_s, :worker_id => @worker.id.to_s
  end
  it "should redirect to task list page" do
    post :assign, :task_id => @task.id.to_s, :worker_id => @worker.id.to_s
    response.should redirect_to("/tasks/list/#{@project.id}/all")
  end
end

describe TasksController, "POST estimate" do
  before(:each) do
    controller.stub!(:menu)
    login_as_lead
    @project = mock_model(Project)
    @client_request = mock_model(ClientRequest, :status => ClientRequest::NEW)
    @task = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::OPEN)
    Task.should_receive(:find).with(@task.id.to_s).and_return @task
  end
  it "should save the task with estimated info" do
    @task.should_receive(:update_attributes).and_return true
    post :estimate, :tasks => {
      :start_date => Time.now + 1.day,
      :due_date => Time.now + 5.day},
      :task_id => @task.id.to_s
  end
  context "save task successfully" do
    it "should redirect to task edit page" do
      @task.should_receive(:update_attributes).and_return true
      post :estimate, :tasks => {
        :start_date => Time.now + 1.day,
        :due_date => Time.now + 5.day},
        :task_id => @task.id.to_s
      response.should redirect_to("/tasks/assign_task/#{@task.id}")
    end
  end
  context "fail to save task" do
    before(:each) do
      @task.should_receive(:update_attributes).and_return false
      post :estimate, :tasks => {
        :start_date => Time.now + 1.day,
        :due_date => Time.now + 5.day},
        :task_id => @task.id.to_s
    end
    it "should set a flash message" do
      flash[:notice].should == "Error when saving task"
    end
    it "should redirect to task show estimate page" do
      response.should redirect_to("/tasks/show_estimate/#{@task.id}")
    end
  end
end

describe TasksController, "POST volunteer" do
  before(:each) do
    controller.stub!(:menu)
    @account = login_as_lead
    @project = mock_model(Project)
    @client_request = mock_model(ClientRequest, :start => true, :status => ClientRequest::NEW)
    @task = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::OPEN)
    Task.should_receive(:find).with(@task.id.to_s).and_return @task
  end

  it "should save the task with estimated info" do
    @task.should_receive(:update_attributes).and_return true
    post :volunteer, :tasks => {
      :start_date => Time.now + 1.day,
      :due_date => Time.now + 5.day},
      :task_id => @task.id.to_s
  end
  it "should assign the task to current account" do
    @task.should_receive(:update_attributes).and_return true
    controller.should_receive(:current_account).and_return @account
    post :volunteer, :tasks => {
      :start_date => Time.now + 1.day,
      :due_date => Time.now + 5.day},
      :task_id => @task.id.to_s
    @task.worker.should == @account
  end
  context "save task successfully" do
    it "should redirect to task edit path" do
      @task.should_receive(:update_attributes).and_return true
      post :volunteer, :tasks => {
        :start_date => Time.now + 1.day,
        :due_date => Time.now + 5.day},
        :task_id => @task.id.to_s
      response.should redirect_to(task_path(@task))
    end
  end
  context "fail to save task" do
    before(:each) do
      @task.should_receive(:update_attributes).and_return false
      post :volunteer, :tasks => {
        :start_date => Time.now + 1.day,
        :due_date => Time.now + 5.day},
        :task_id => @task.id.to_s
    end
    it "should set a flash message" do
      flash[:notice].should == "Error when saving task"
    end
    it "should redirect to task show volunteer page" do
      response.should redirect_to("/tasks/show_volunteer/#{@task.id}")
    end
  end
end

describe TasksController, "GET assign_task" do
  before(:each)   do
    controller.stub!(:menu)
    @account = login_as_lead
    @worker_group = mock_model(WorkerGroup)
    @project = mock_model(Project, :worker_group => @worker_group)
    @client_request = mock_model(ClientRequest, :start => true, :status => ClientRequest::NEW)
    @client_request_change = mock_model(ClientRequestChange)
    @task = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::OPEN)
    Task.should_receive(:find).with(@task.id.to_s).and_return @task
    @task_list = []
    @worker_list = []
    (1..3).each { @task_list << mock_model(Task)}
    (1..3).each { @worker_list << mock_model(Worker) }
    Worker.should_receive(:worker_with_least_assigned_hours).and_return @worker_list[0]
    Task.should_receive(:worker_task_list).with(@worker_list[0].id, Task::ASSIGNED).and_return @task_list
    @worker_group.stub!(:accounts).and_return @worker_list
  end

  it "should get active worker who has least assigned task" do
    get :assign_task, :id => @task.id.to_s
    assigns[:active_worker].should == @worker_list[0]
  end
  it "should get list of assigned tasks for the active worker" do
    get :assign_task, :id => @task.id.to_s
    assigns[:active_task_list].should == @task_list
  end

  it "should get worker list from project worker group" do
    get :assign_task, :id => @task.id.to_s
    assigns[:worker_list].should == @worker_list
  end
end



describe TasksController, "GET show" do
  before(:each)   do
    controller.stub!(:menu)
    @params = {:page => "1"}
    @account = login_as_lead
    @worker_group = mock_model(WorkerGroup)
    @project = mock_model(Project, :worker_group => @worker_group)
    @client_request = mock_model(ClientRequest, :start => true)
    @task = Factory(:task, :project => @project, :client_request => @client_request)
    Task.should_receive(:find_by_id).with(@task.id.to_s, @account).and_return @task
    @client_request_change = mock("List of client request changes with pagination")
    ClientRequestChange.should_receive(:paginate_by_client_request).with(@task.client_request_id, nil).and_return @client_request_change
    @message = mock("List of developer discussion on taks with pagination")
    Message.should_receive(:developer_discussion_on_task).with(@task.id.to_i, @params[:page]).and_return @message
    @client_msg = mock("List of client message with pagination")
    ClientMessage.should_receive(:client_discussion_on_task).with(@task.client_request_id, @params[:page]).and_return @client_msg
    @attached_files_tech = mock("List of attached files with pagination")
    AttachedFile.should_receive(:paginate_by_task).with(@task.id, nil).and_return @attached_files_tech
    @attached_files = mock("List of attached files with pagination")
    AttachedFile.should_receive(:paginate_by_client_request).with(@task.client_request_id, nil).and_return @attached_files
    @technical = mock("List of paginate technical_note")
    TechnicalNote.should_receive(:paginate_by_task).with(@task.id, nil).and_return @technical
   end

   it "should get list of client change request from a task" do
    get :show, :id => @task.id.to_s, :page => @params[:page]
    assigns[:client_request_changes].should == @client_request_change
  end
  it "should get list of task from a task" do
    get :show, :id => @task.id.to_s, :page => @params[:page]
    assigns[:task].should == @task
  end
    it "should get list of client message from a task" do
    get :show, :id => @task.id.to_s, :page => @params[:page]
    assigns[:client_msg].should == @client_msg
  end
end



describe TasksController, "POST save_message_dev" do
  before(:each)   do
    controller.stub!(:menu)
    @account = login_as_lead
    @account.stub(:id).and_return 1
    @attributes= {"task_id" => "1", "body" =>"the description", "sender_id" => "5"}
    @message = mock_model(Message, :body => "the description", :task_id => "1", :sender_id => "5", :task => mock_model(Task))
    Message.should_receive(:new).with(@attributes).and_return(@message)
    @message.should_receive(:title=).with(@attributes["body"])
 end

  it "should be save successfull" do
     @message.should_receive(:save).and_return(false)
     post :save_message_dev, :message => @attributes
 #    response.body.should =~ /Message.dev_after_save()/#ruby 502
#    @message.should_receive(:save).and_return true
#    @message.should_receive(:errors).and_return []
#    Message.should_receive(:init_message_status).with(@message)
#    @messages = mock("List of client request changes", {
#          :empty? => false, :current_page => 1, :each => 1,
#          :first => @message, :total_pages => 1
#        })
#    Message.stub!(:developer_discussion_on_task).with(@message.task_id, 1).and_return(@messages)
#    post :save_message_dev, :message => @attributes
#    response.body.should =~ /Message.dev_after_save()/
#    response.body.should =~ /dev-message-list/
#    response.body.should =~ /highlight/
  end

  it "should be save unsuccessfull" do
    @message.should_receive(:save).and_return(false)
    post :save_message_dev, :message => @attributes
    response.body.should =~ /#newDevMessageError/
  end

end

describe TasksController, "GET show_task_list" do
  before(:each) do
    controller.stub!(:menu)
    @account = login_as_lead
    @project = mock_model(Project)
    @client_request = mock_model(ClientRequest, :start => true, :status => ClientRequest::NEW)
    @worker = mock_model(Worker)
  end

  it "none task assigned for user" do
    @task_list = []
    Task.should_receive(:worker_task_list).with(@worker_id, "assigned").and_return @task_list
    get :show_task_list
  end

  it "return a list tasks assigned for user" do
    @task1 = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::ASSIGNED, :worker_id => @worker.id)
    @task2 = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::ASSIGNED, :worker_id => @worker.id)
    @task_list = [@task1, @task2]
    Task.should_receive(:worker_task_list).with(@worker_id, "assigned").and_return @task_list
    get :show_task_list
  end

end

describe TasksController, "GET find a task" do
  before(:each) do
    controller.stub!(:menu)
    login_as_lead
    @project = mock_model(Project)
    @client_request = mock_model(ClientRequest, :start => true, :status => ClientRequest::NEW)
    @task = Factory(:task, :project => @project, :client_request => @client_request, :status => Task::OPEN)
  end

  it "return a task to estimate" do
     Task.should_receive(:find).with(@task.id.to_s).and_return @task
     get :show_estimate, :id => @task.id.to_s
  end

  it "return a task for volunteer" do
     Task.should_receive(:find).with(@task.id.to_s).and_return @task
     get :show_volunteer, :id => @task.id.to_s
  end

end


describe TasksController, "Delete message discussion" do
  before(:each) do
    controller.stub!(:menu)
    login_as_worker
    @params = {:message_id => 1, :page => 1}
    @message = mock_model(Message, :id => 1, :task_id => 1, :task => mock_model(Task))
    Message.should_receive(:find).with(@params[:message_id]).and_return @message
  end
  it "Delete successfully" do
    @message.should_receive(:destroy).and_return true
   # @messages = mock("List of client request changes")
    Message.stub!(:developer_discussion_on_task).with(@message.task_id, 1).and_return(@messages)
    get :delete_message_dev, :message_id => @params[:message_id], :page => 1
    response.should render_template "tasks/_dev_messages"
  end
end



describe TasksController, "POST add_note" do
  before(:each)   do
    controller.stub!(:menu)
    login_as_worker
    @attributes= {"task_id" => "1", "description" =>"the description"}
    @note = mock_model(TechnicalNote, :description => "the description", :task_id => "1")
    TechnicalNote.should_receive(:new).with(@attributes).and_return(@note)
 end

 it "should be add note successfull" do
    @note.should_receive(:save).and_return true

    technical_notes = mock("List of tech note", {
      :empty? => false, :current_page => 1, :each => 1,
      :total_pages => 1
    })
    TechnicalNote.should_receive(:paginate_by_task).with(@note.task_id, 1).and_return technical_notes
    post :add_note, :technical_note => @attributes
    response.body.should =~ /AddNote.afterSave/
    response.body.should =~ /note_list/
    response.body.should =~ /highlight/

  end

  it "should be add note unsuccessfull" do
    @note.should_receive(:save).and_return false
    post :add_note, :technical_note => @attributes
  end

end

describe TasksController, "GET tech_note_paginate" do
  it "should be to do" do
    controller.stub!(:menu)
    login_as_worker
    params = {:id => "1", :page => 1}
    task_id = params[:id]
    tech_note = mock("List of paginate of technical note")
    TechnicalNote.stub!(:paginate_by_task).with(task_id, params[:page]).and_return tech_note
    #response.should render_template('view/tech_note_paginate.js')
  end
end

describe TasksController, "GET developer_discussion" do
  it "should be to do" do
    controller.stub!(:menu)
    login_as_worker
    params = {:id => "1", :page => "1"}
    task_id = params[:id]
    message = mock_model(Message, :body => "the description", :task_id => "1", :sender_id => "5", :task => mock_model(Task))
    messages = mock("List of client request changes", {
          :empty? => false, :current_page => 1, :each => 1,
          :first => message, :total_pages => 1
        })
    Message.stub!(:developer_discussion_on_task).with(params[:id], params[:page]).and_return(messages)
    #post :developer_discussion, :id => params[:id], :page => params[:page]
  end
end

describe TasksController, "POST save_message_client" do
  before(:each)   do
    controller.stub!(:menu)
    @account = login_as_worker
    @account.stub(:id).and_return 1
    @attributes= {"client_request_id" => "1", "body" =>"the description", "sender_id" => "5"}
    @message = mock_model(ClientMessage, :body => "the description", :client_request_id => "1", :sender_id => "5")
    ClientMessage.should_receive(:new).with(@attributes).and_return(@message)
    @message.should_receive(:title=).with(@attributes["body"])
 end

  it "should be save successfull" do
    @message.should_receive(:save).and_return true
    @message.should_receive(:errors).and_return []
    ClientMessage.should_receive(:init_message_status).with(@message)
    @messages = mock("List of client request changes", {
          :empty? => false, :current_page => 1, :each => 1,
          :first => @message, :total_pages => 1
        })
    ClientMessage.should_receive(:client_discussion_on_task).with(@message.client_request_id, 1).and_return(@messages)
    post :save_message_client, :client_message => @attributes
    response.body.should =~ /Message.client_after_save()/
    response.body.should =~ /client-message-list/
    response.body.should =~ /highlight/
  end

  it "should be save unsuccessfull" do
    @message.should_receive(:save).and_return(false)
    post :save_message_client, :client_message => @attributes
    response.body.should =~ /#newClientMessageError"/
  end
end

describe TasksController, "GET client_discussion" do
  it "should be to do" do
    login_as_client
     controller.stub!(:menu)
    params = {:id => "1", :page => "1"}
    client_request_id = params[:id]
    message = mock_model(ClientMessage, :description => "the description", :client_request_id => "1", :sender_id => "5")
    messages = mock("List of client request changes", {
          :empty? => false, :current_page => 1, :each => 1,
          :first => message, :total_pages => 1
        })
    ClientMessage.should_receive(:client_discussion_on_task).with(client_request_id, params[:page]).and_return(messages)
    post :client_discussion, :id => params[:id], :page => params[:page]
  end
end

describe TasksController, "GET set_note_description" do
  it "should be keep the current description" do
    controller.stub!(:menu)
    login_as_worker
    params = {:id => "1", :value => ""}
    note = mock_model(TechnicalNote, :id => "1", :description => "Hello")
    TechnicalNote.should_receive(:find).with(params[:id]).and_return note
    params[:value].should be_empty
    post :set_note_description, :id => params[:id], :value => params[:value]
    response.body.should == "Hello"
  end

  it "should be description updated" do
    controller.stub!(:menu)
    login_as_worker
    params = {:id => "1", :value => "chao"}
    note = mock_model(TechnicalNote)
    TechnicalNote.should_receive(:find).with(params[:id]).and_return note
    params[:value].should_not be_empty
    note.should_receive(:description=).with(params[:value])
    note.should_receive(:save).and_return true
    note.should_receive(:description).and_return params[:value]
    get :set_note_description, :id => params[:id], :value => params[:value]
    response.body.should == params[:value]
  end

end


describe TasksController, "GET delete_note" do
  it "should be delete successfully" do
    controller.stub!(:menu)
    login_as_worker
    params = {:id => "1", :page => "1"}
    note_id = params[:id]
    note = mock_model(TechnicalNote, :task_id => 1)
    TechnicalNote.should_receive(:find_by_id).with(note_id).and_return note
    note.should_receive(:destroy)
    notes = Array.new
    TechnicalNote.should_receive(:paginate_by_task).with(note.task_id, params[:page].to_i).and_return notes
    get :delete_note, :id => params[:id], :page => params[:page]
  end
end

describe TasksController, "Delete delete_message_client" do
  before(:each) do
    controller.stub!(:menu)
    login_as_worker
    @params = {:message_id => "1", :page => "1"}
    @client_message = mock_model(ClientMessage, :client_request_id => 1)
    ClientMessage.should_receive(:find).with(@params[:message_id]).and_return @client_message
  end

  it "Delete successfully" do
    @client_message.should_receive(:destroy).and_return true
    client_messages = mock("List of client request changes")
    ClientMessage.should_receive(:client_discussion_on_task).with(@client_message.client_request_id, @params[:page]).and_return client_messages
    get :delete_message_client, :message_id => @params[:message_id], :page => @params[:page]
    response.should render_template "tasks/_client_messages"
  end
end

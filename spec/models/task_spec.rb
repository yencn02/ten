require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  describe "paginate by status" do
    before(:each) do
      @worker_group = Factory(:worker_group)
      @worker = Worker.new(:worker_groups => [@worker_group], :id => 1) 
    end
    it "should raise SecurityError if account is nil" do
      lambda{
        Task.paginate_by_status(nil, nil, nil, nil)
      }.should raise_error(SecurityError)
    end
    it "should raise RecordNotFound error if status is not correct" do
      lambda{
        Task.paginate_by_status("wrong", nil, nil, @worker)
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
    it "should return tasks of all projects in my group if project_id is nil" do
      projects = []
      (1..2).each do |i|
        projects << mock_model(Project, :worker_group => @worker_group)
        (1..3).each do 
          Factory(:task, :project => projects[i-1], :client_request => mock_model(ClientRequest), :status => Task::UNASSIGNED)
        end        
      end
      Project.should_receive(:find_by_account).with(@worker).and_return projects
      tasks = Task.paginate_by_status(Task::UNASSIGNED, nil, nil, @worker)
      tasks.count.should == 6
    end
    
    it "should return tasks for specific project" do
      project = mock_model(Project, :worker_group => @worker_group)
      (1..3).each do 
        Factory(:task, :project => project, :client_request => mock_model(ClientRequest), :status => Task::UNASSIGNED)
      end
      Project.should_receive(:find_by_id).with(project.id, @worker).and_return project
      tasks = Task.paginate_by_status(Task::UNASSIGNED, project.id, nil, @worker)
      tasks.count.should == 3      
    end

    describe "should return tasks for with specific status" do
      before(:each) do
        @project = mock_model(Project, :worker_group => @worker_group)
        (1..3).each do 
          Factory(:task, :project => @project, :client_request => mock_model(ClientRequest), :status => Task::UNASSIGNED)
          Factory(:task, :project => @project, :client_request => mock_model(ClientRequest), :status => Task::ASSIGNED) 
          Factory(:task, :project => @project, :client_request => mock_model(ClientRequest), :status => Task::COMPLETED)
          Factory(:task, :project => @project, :client_request => mock_model(ClientRequest), :status => Task::VERIFIED) 
        end
        Project.should_receive(:find_by_id).with(@project.id,@worker).and_return @project
      end
      it "should return OPEN tasks if status is OPEN" do
        tasks = Task.paginate_by_status(Task::UNASSIGNED, @project.id, nil, @worker)
        tasks.count.should == 3
        tasks.each { |task|  task.status.should == Task::UNASSIGNED }
      end
      it "should return ASSGIGNED tasks if status is ASSIGNED" do
        tasks = Task.paginate_by_status(Task::ASSIGNED, @project.id, nil, @worker)
        tasks.count.should == 3
        tasks.each { |task|  task.status.should == Task::ASSIGNED }
      end
      it "should return COMPLETE tasks if status is COMPLETE" do
        tasks = Task.paginate_by_status(Task::COMPLETED, @project.id, nil, @worker)
        tasks.count.should == 3
        tasks.each { |task|  task.status.should == Task::COMPLETED }
      end

      it "should return VERIFIED tasks if status is VERIFIED" do
        tasks = Task.paginate_by_status(Task::VERIFIED, @project.id, nil, @worker)
        tasks.count.should == 3
        tasks.each { |task|  task.status.should == Task::VERIFIED }
      end
    end
  
  end
  describe "worker_task_list" do    
    describe "return tasks assigned to worker with specific status" do   
      before(:each) do
        @worker_group = Factory(:worker_group)
        @worker = Factory(:worker, :worker_groups => [@worker_group]) 
        @project = mock_model(Project, :worker_group => @worker_group)
        (1..3).each do 
          Factory(:task, :project => @project, :worker => @worker, :client_request => mock_model(ClientRequest), :status => Task::ASSIGNED) 
          Factory(:task, :project => @project, :worker => @worker, :client_request => mock_model(ClientRequest), :status => Task::COMPLETED)
          Factory(:task, :project => @project, :worker => @worker, :client_request => mock_model(ClientRequest), :status => Task::VERIFIED) 
        end
      end      
      it "should return ASSGIGNED task if stats is ASSGIGNED" do
        tasks = Task.worker_task_list(@worker.id, Task::ASSIGNED) 
        tasks.count.should == 3
        tasks.each do |task|
          task.status.should == Task::ASSIGNED
          task.worker.should == @worker
        end
      end
      it "should return COMPLETE task if stats is COMPLETE" do
        tasks = Task.worker_task_list(@worker.id, Task::COMPLETED)
        tasks.count.should == 3
        tasks.each do |task|
          task.status.should == Task::COMPLETED
          task.worker.should == @worker
        end
      end
      it "should return VERIFIED task if stats is VERIFIED" do
        tasks = Task.worker_task_list(@worker.id, Task::VERIFIED) 
        tasks.count.should == 3
        tasks.each do |task|
          task.status.should == Task::VERIFIED
          task.worker.should == @worker
        end
      end
    end
  end
  
  describe "total_billed_hours" do
    it "should return total bill hour for task" do
      worker = mock_model(Worker)
      project = mock_model(Project)
      client_request = mock_model(ClientRequest)
      task = Factory(:task, :project => project, :worker => worker, :client_request => client_request, :status => Task::ASSIGNED)
      BillableTime.should_receive(:sum).with("billed_hour", :conditions => {:task_id => task.id}).and_return "10"
      task.total_billed_hours.should == "10"
    end
  end
  
  describe "find_by_id" do 
    before :each do
      @worker = mock_model(Worker)
      project = mock_model(Project)
      client_request = mock_model(ClientRequest)
      @task = Factory(:task, :project => project, :worker => @worker, :client_request => client_request, :status => Task::ASSIGNED)      
    end
    it "should raise ArgumentError if given account is nil" do
      lambda{
        Task.find_by_id(nil, nil)
      }.should raise_error(ArgumentError)
    end
    it "should raise Security error if given account is not allowed to view" do
      Task.stub!(:find).with(@task.id).and_return @task
      @task.should_receive(:allows_view?).with(@worker).and_return false
      lambda{
        Task.find_by_id(@task.id, @worker)
      }.should raise_error(SecurityError)
    end
    it "should return task by id if given account is allowed to view"  do
      Task.stub!(:find).with(@task.id).and_return @task
      @task.should_receive(:allows_view?).with(@worker).and_return true
      Task.find_by_id(@task.id, @worker).should == @task
    end
  end
  
  describe "#recent_count" do
    it "should be 0" do
      project_id = mock("project_id")
      Task.recent_count(project_id).should == 0
    end
  end

  describe "#find_by_status" do
    before :each do
      index = rand(5)
      index +=1 if index == 0
      @status = Task.visible_task_statuses[index]
      @project_id = mock("project_id")
      @account = mock("account")
    end
    
    it "account is nil, SecurityError" do
      lambda{
        Task.find_by_status(@status, @project_id, nil)
      }.should raise_error(SecurityError)
    end

    it "ActiveRecord::RecordNotFound" do
      lambda{
        Task.find_by_status(mock("status"), @project_id, @account)
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "project_id is nil" do
      projects = []
      (rand(10)+1).times do |i|
        projects << mock("project", :id => i)
      end
      Project.should_receive(:find_by_account).with(@account).and_return projects
      project_ids = projects.collect {|project| project.id}
      results = mock("results")
      Task.should_receive(:all).with(:conditions => {:status => @status, :project_id => project_ids},:order => "created_at DESC").and_return results
      Task.find_by_status(@status, nil, @account).should == results
    end

    it "project_id is not equal 'all'" do
      project = mock_model(Project, :id => 1)
      Project.should_receive(:find_by_id).with(@project_id, @account).and_return project
      results = mock("results")
      Task.should_receive(:all).with(:conditions => {:status => @status, :project_id => project.id},:order => "created_at DESC").and_return results
      Task.find_by_status(@status, @project_id, @account).should == results
    end
  end

  describe "Instance Methods" do
    before :each do
      @task = Task.new
    end

    describe "#allows_access?" do
      it "ArgumentError" do
        lambda{
          @task.allows_access?(nil)
        }.should raise_error(ArgumentError)
      end

      it "is my task" do
        account = mock("account", :id => 1)
        @task.stub(:worker_id).and_return 1
        @task.allows_access?(account).should be_true
      end

      it "is not my task" do
        account = mock("account", :id => 1)
        @task.stub(:worker_id).and_return 2
        @task.allows_access?(account).should be_false
      end
    end

    describe "#allows_update?" do
      it "ArgumentError" do
        lambda{
          @task.allows_update?(nil)
        }.should raise_error(ArgumentError)
      end

      it "has role admin" do
        account = mock("account")
        account.stub(:has_role?).with(Role::ADMIN).and_return true
        @task.allows_update?(account).should == true
      end

      it "account is not a lead or manager or admin" do
        account = mock("account")
        account.stub(:has_role?).with(Role::ADMIN).and_return false
        account.stub(:has_role?).with(Role::MANAGER).and_return false
        account.stub(:has_role?).with(Role::LEAD).and_return false
        @task.allows_update?(account).should == false
      end
      
      describe "account is a lead or manager" do
        before :each do
          @account = mock("account")
        end

        it "- has role manager" do
          @account.stub(:has_role?).with(Role::ADMIN).and_return false
          @account.stub(:has_role?).with(Role::MANAGER).and_return true
        end

        it "- has role lead" do
          @account.stub(:has_role?).with(Role::ADMIN).and_return false
          @account.stub(:has_role?).with(Role::MANAGER).and_return false
          @account.stub(:has_role?).with(Role::LEAD).and_return true
        end

        after :each do
          worker_groups = mock("worker_groups")
          @account.should_receive(:worker_groups).and_return worker_groups
          worker_group = mock("worker_group")
          project = mock("project", :worker_group => worker_group)
          @task.should_receive(:project).and_return project
          worker_groups.should_receive(:include?).with(project.worker_group).and_return true
          @task.allows_update?(@account).should == true
        end
      end
    end##allows_update?

    describe "#allows_view?" do
      it "ArgumentError" do
        lambda{
          @task.allows_view?(nil)
        }.should raise_error(ArgumentError)
      end

      it "has role admin" do
        account = mock("account")
        account.stub(:has_role?).with(Role::ADMIN).and_return true
        @task.allows_view?(account).should == true
      end

      it "is a worker" do
        account = mock("account")
        account.stub(:has_role?).with(Role::ADMIN).and_return false
        worker_groups = mock("worker_groups")
        account.should_receive(:worker_groups).and_return worker_groups
        worker_group = mock("worker_group")
        project = mock("project", :worker_group => worker_group)
        @task.should_receive(:project).and_return project
        worker_groups.should_receive(:include?).with(project.worker_group).and_return true
        @task.allows_view?(account).should == true
      end
    end

    describe "#validate_data" do
      it "error with nil start_date & due_date" do
        @task.validate_data
        @task.errors.on(:start_date).should_not be_nil
        @task.errors.on(:due_date).should_not be_nil
      end
      
      it "start_date > due_date" do
        @task.start_date = Date.today
        @task.due_date = Date.today - 1
        @task.validate_data
        @task.errors.on(:start_date).should_not be_nil
        @task.errors.on(:due_date).should_not be_nil
      end
    end
  end#Instance Methods
  
end
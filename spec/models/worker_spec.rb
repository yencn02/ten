require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Worker do
  describe "#association" do   

    it "#with :tasks" do
      association = Worker.reflect_on_association(:tasks)
      association.macro.should == :has_many      
      association.class_name.should == 'Task'
    end
    it "#with :roles" do
      association = Worker.reflect_on_association(:roles)
      association.macro.should == :has_and_belongs_to_many
      association.class_name.should == 'Role'
    end
  end

  describe "#valid?" do
    before(:each) do
      @valid_attributes = {
        :name => "worker",
        :password => "123456",
        :password_confirmation => "123456",
        :email => "test@endax.com",
        :login => "test"
      }
    end
    it "should not create a new instance without worker_groups and roles" do
      worker = Worker.new(@valid_attributes)
      worker.valid?.should be_false
    end

    it "should not create a new instance without roles" do
      company = Factory.create(:company, :name => "Endax")
      worker_group = Factory.create(:worker_group, :name => "Tigrer", :company => company)
      @valid_attributes[:worker_groups] = [worker_group]
      worker = Worker.new(@valid_attributes)
      worker.valid?.should be_false
    end
    it "should not create a new instance without worker_groups" do
      role = Factory(:role, :name => "Manager")
      @valid_attributes[:roles] = [role]
      worker = Worker.new(@valid_attributes)
      worker.valid?.should be_false
    end
    it "should create a new instance successfully" do
      company = Factory.create(:company, :name => "Endax")
      worker_group = Factory.create(:worker_group, :name => "Tigrer", :company => company)
      role = Factory(:role, :name => "Manager")
      @valid_attributes[:worker_groups] = [worker_group]
      worker = Worker.new(@valid_attributes)
      worker.roles = [role]
      worker.save.should be_true
    end
  end

  describe "Class Methods" do
    describe "#paginate_by_activity" do
      it "should return nil" do
        Worker.paginate_by_activity(nil, 1).should be_nil
      end
      it "should return related worker ids" do
        page = 1
        account = mock_model(Worker)
        account.stub(:has_role?).with(Role::ADMIN).and_return false
        worker_ids = mock("List of worker's IDs")
        account.stub(:worker_ids).and_return worker_ids
        expected_results = mock("Results")
        Worker.should_receive(:paginate).with(:page => page, :per_page => $menu_number_of_workers,
          :conditions => {:id => worker_ids, :enabled => true}, :order => "activity DESC").and_return expected_results
        Worker.paginate_by_activity(account, page).should == expected_results
      end
      it "should return all worker ids" do
        page = 1
        account = mock_model(Worker)
        account.stub(:has_role?).with(Role::ADMIN).and_return true
        worker_ids = mock("List of worker's IDs")
        account.stub(:worker_ids).and_return worker_ids
        expected_results = mock("Results")
        Worker.should_receive(:paginate).with(:page => page, :per_page => $menu_number_of_workers,
          :conditions => {:enabled => true}, :order => "activity DESC").and_return expected_results
        Worker.paginate_by_activity(account, page).should == expected_results
      end
    end
  
    describe "#worker_with_no_tasks_assigned" do
      it "should return a worker who haven't assigned tasks" do
        project_id = 1
        project = mock_model(Project)
        workers = [mock_model(Worker, :id => 1), mock_model(Worker, :id => 2)]
        worker_group = mock_model(WorkerGroup)
        Project.should_receive(:find).with(project_id).and_return project
        project.should_receive(:worker_group).and_return(worker_group)
        worker_group.should_receive(:accounts).and_return(workers)
        tasks = mock("tasks")
        expected_worker = nil
        workers.each do |worker|
          task = nil
          Task.should_receive(:where).with("project_id = ? AND worker_id = ? AND status = ?", project_id, worker.id, 'assigned').and_return tasks
          tasks.should_receive(:first).and_return task
          expected_worker = worker
          break
        end
        Worker.worker_with_no_tasks_assigned(project_id).should == expected_worker
      end

      it "should return not found a worker that no assiged tasks" do
        project_id = 1
        project = mock_model(Project)
        workers = [mock_model(Worker, :id => 1), mock_model(Worker, :id => 2)]
        worker_group = mock_model(WorkerGroup)
        Project.should_receive(:find).with(project_id).and_return project
        project.should_receive(:worker_group).and_return(worker_group)
        worker_group.should_receive(:accounts).and_return(workers)
        expected_worker = nil
        tasks = mock("tasks")
        workers.each do |worker|
          task = mock("Task")
          Task.should_receive(:where).with("project_id = ? AND worker_id = ? AND status = ?", project_id, worker.id, 'assigned').and_return tasks
          tasks.should_receive(:first).and_return task
        end
        Worker.worker_with_no_tasks_assigned(project_id).should == expected_worker
      end
    end
  
    describe "#worker_with_least_assigned_hours" do
      it "should return a worker who haven't assigned tasks" do
        project_id = 1
        worker_with_least_assigned_hours = mock("Some things")
        Worker.should_receive(:worker_with_no_tasks_assigned).with(project_id).and_return worker_with_least_assigned_hours
        Worker.worker_with_least_assigned_hours(project_id).should == worker_with_least_assigned_hours
      end

      it "should not find a worker with least assigned hours" do
        project_id = 1
        worker_with_least_assigned_hours = nil
        Worker.should_receive(:worker_with_no_tasks_assigned).with(project_id).and_return worker_with_least_assigned_hours
        workload = nil
        Task.should_receive(:first).with(
          :select => "worker_id, SUM(estimated_hours) AS workload",
          :include => :worker,
          :conditions => ["status = ? AND project_id = ?", :assigned.to_s, project_id],
          :group => "worker_id",
          :order => "workload ASC").and_return workload
        Worker.worker_with_least_assigned_hours(project_id).should == worker_with_least_assigned_hours

      end

      it "should return a worker with least assigned hours" do
        project_id = 1
        worker_with_least_assigned_hours = nil
        Worker.should_receive(:worker_with_no_tasks_assigned).with(project_id).and_return worker_with_least_assigned_hours

        worker_id = 1
        workload = mock("Some things")
        workload.stub(:worker_id).and_return worker_id
        Task.should_receive(:first).with(
          :select => "worker_id, SUM(estimated_hours) AS workload",
          :include => :worker,
          :conditions => ["status = ? AND project_id = ?", :assigned.to_s, project_id],
          :group => "worker_id",
          :order => "workload ASC").and_return workload

        worker_obj = mock_model(Worker)
        Worker.should_receive(:find).with(workload.worker_id).and_return worker_obj

        Worker.worker_with_least_assigned_hours(project_id).should == worker_obj

      end
    end
  end #Class Methods

  describe "Instance Methods" do
    before :each do
      @worker = Worker.new
    end

    it "#admin_worker_path" do
      path = "/admin/workers/#{@worker.id}"
      @worker.admin_worker_path.should == path
    end

    it "#projects" do
      worker_groups = []
      projects = []
      (rand(100)+1).times do
        ps = []
        (rand(10) + 1).times do
          ps << mock_model(Project)
        end
        worker_groups << mock_model(WorkerGroup, :projects => ps)
        projects.concat(ps)
      end
      @worker.stub(:worker_groups).and_return worker_groups
      @worker.projects.should == projects
    end

    it "#project_ids" do
      projects = []
      (rand(10) + 1).times do |i|
        projects << mock_model(Project, :id => i)
      end
      @worker.stub(:projects).and_return projects
      @worker.project_ids.should == projects.map{|x| x.id}
    end

    it "#messages" do
      status = "status"
      page = 1
      per_page = 3
      conditions = {"message_statuses.account_id" => @worker.id }
      conditions["message_statuses.status"] = status
      expected = Message.joins(:message_statuses).paginate(:page => page, :per_page => per_page, :conditions =>  conditions, :order => "created_at DESC")
      @worker.messages(status, page, per_page).should == expected
    end

    it "#client_messages" do
      status = "status"
      page = 1
      per_page = 3
      conditions = {"client_message_statuses.account_id" => @worker.id }
      conditions["client_message_statuses.status"] = status
      expected = ClientMessage.joins(:client_message_statuses).paginate(:page => page, :per_page => per_page, :conditions =>  conditions, :order => "created_at DESC")
      @worker.client_messages(status, page, per_page).should == expected
    end

    it "#total_billed_hours" do
      tasks = mock("List of tasks")
      @worker.should_receive(:tasks).and_return tasks
      task_ids = mock("List of task ids")
      tasks.should_receive(:all).with(:select => "id").and_return task_ids
      total_billed_hours = mock("result")
      BillableTime.should_receive(:sum).with("billed_hour", :conditions => {:task_id => task_ids}).and_return total_billed_hours
      @worker.total_billed_hours.should == total_billed_hours
    end

    it "#billed_hours_on_project" do
      project_id = mock("project_id")
      tasks = mock("List of tasks")
      @worker.should_receive(:tasks).and_return tasks
      task_ids = mock("List of task ids")
      tasks.should_receive(:all).with(:select => "id", :conditions => {:project_id => project_id}).and_return task_ids
      billed_hours_on_project = mock("result")
      BillableTime.should_receive(:sum).with("billed_hour", :conditions => {:task_id => task_ids}).and_return billed_hours_on_project
      @worker.billed_hours_on_project(project_id).should == billed_hours_on_project
    end
  end#Instance Methods
end
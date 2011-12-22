require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Project do
  describe "Class methods" do
    describe "#pagination by activity" do
      it "account is nil" do
        Project.paginate_by_activity(nil, nil, nil).should be_nil
      end
      context "account is not nil" do
        before :each do
          @status = mock("status")
          @page = mock("page")
          @per_page = mock("per_page")
          @projects = mock("projects")
        end
        it "account is an admin" do
          @account = mock_model(Worker)
          @account.stub(:has_role?).with(Role::ADMIN).and_return true
          Project.should_receive(:paginate).with(:page => @page, :conditions => {:status => @status},
            :per_page => @per_page, :order => "activity DESC").and_return @projects
        end
    
        it "account is a client" do
          @account = mock_model(Client)
          client_groups = []
          (rand(10)+1).times do |i|
            client_groups  << mock_model(ClientGroup, :id => i)
          end
          @account.stub(:client_groups).and_return client_groups
          client_group_ids = @account.client_groups.collect {|g| g.id}
          Project.should_receive(:paginate).with(:page => @page, :per_page => @per_page,
            :conditions => {:client_group_id => client_group_ids, :status => @status}, :order => "activity DESC").and_return @projects
        end

        it "account as a worker" do
          @account = mock_model(Worker)
          @account.stub(:has_role?).with(Role::ADMIN).and_return false
          worker_groups = []
          (rand(10)+1).times do |i|
            worker_groups << mock_model(WorkerGroup, :id => i)
          end
          @account.stub(:worker_groups).and_return worker_groups
          worker_group_ids = @account.worker_groups.collect {|g| g.id}
          Project.should_receive(:paginate).with(:page => @page, :per_page => @per_page, :conditions => {
              :worker_group_id => worker_group_ids, :status => @status}, :order => "activity DESC").and_return @projects
        end

        after :each do
          Project.paginate_by_activity(@account, @status, @page, @per_page).should == @projects
        end
      end
    end
  
    describe "#find_by_id" do
      it "should not raise SecurityError error if project is nil" do
        lambda{
          Project.find_by_id(nil, nil)
        }.should_not raise_error(SecurityError)
      end
    
      it "should raise SecurityError error if project is nil" do
        @client_group = Factory(:client_group)
        @client = Factory(:client, :client_groups => [@client_group])
        @project = Factory(:project)
        lambda{
          Project.find_by_id(@project.id, @client)
        }.should raise_error(SecurityError)
      end
    end

    describe "#most_active" do
      it "account is nil" do
        Project.most_active(nil).should be_nil
      end
      context "account is not nil" do
        before :each do
          @most_active = mock("projects")
        end
        it "account is an admin" do
          @account = mock_model(Worker)
          @account.stub(:has_role?).with(Role::ADMIN).and_return true
          Project.should_receive(:first).with(:order => "activity DESC").and_return @most_active
        end

        it "account is a client" do
          @account = mock_model(Client)
          client_groups = []
          (rand(10)+1).times do |i|
            client_groups  << mock_model(ClientGroup, :id => i)
          end
          @account.stub(:client_groups).and_return client_groups
          client_group_ids = @account.client_groups.collect {|g| g.id}
          Project.should_receive(:first).with(:conditions => {:client_group_id => client_group_ids},
            :order => "activity DESC").and_return @most_active
        end

        it "account as a worker" do
          @account = mock_model(Worker)
          @account.stub(:has_role?).with(Role::ADMIN).and_return false
          worker_groups = []
          (rand(10)+1).times do |i|
            worker_groups << mock_model(WorkerGroup, :id => i)
          end
          @account.stub(:worker_groups).and_return worker_groups
          worker_group_ids = @account.worker_groups.collect {|g| g.id}
          Project.should_receive(:first).with(:conditions => {:worker_group_id => worker_group_ids},
            :order => "activity DESC").and_return @most_active
        end

        after :each do
          Project.most_active(@account).should == @most_active
        end
      end
    end

    describe "#find_by_account" do
      it "account is nil" do
        lambda{
          Project.find_by_account(nil)
        }.should raise_error(SecurityError)
      end

      it "account is a worker" do
        account = mock_model(Worker)
        projects = []
        worker_groups = []
        (rand(10) + 1).times do
          ps = []
          (rand(5) + 1).times do
            ps << mock_model(Project)
          end
          projects.concat(ps)
          worker_groups << mock_model(WorkerGroup, :projects => ps)
        end
        account.stub(:worker_groups).and_return worker_groups
        Project.find_by_account(account).should == projects
      end

      it "account is a client" do
        account = mock_model(Client)
        projects = []
        client_groups = []
        (rand(10) + 1).times do
          ps = []
          (rand(5) + 1).times do
            ps << mock_model(Project)
          end
          projects.concat(ps)
          client_groups << mock_model(ClientGroup, :projects => ps)
        end
        account.stub(:client_groups).and_return client_groups
        Project.find_by_account(account).should == projects
      end
    end

    describe "#top_active_projects" do
      it "account is nil" do
        Project.most_active(nil).should be_nil
      end
      context "account is not nil" do
        before :each do
          @top_active = mock("projects")
        end
        it "account is an admin" do
          @account = mock_model(Worker)
          @account.stub(:has_role?).with(Role::ADMIN).and_return true
          Project.should_receive(:all).with(:limit => Project::NUMBER_OF_TOP_ACTIVE_PROJECTS, :order => "activity DESC").and_return @top_active
        end

        it "account is a client" do
          @account = mock_model(Client)
          client_groups = []
          (rand(10)+1).times do |i|
            client_groups  << mock_model(ClientGroup, :id => i)
          end
          @account.stub(:client_groups).and_return client_groups
          client_group_ids = @account.client_groups.collect {|g| g.id}
          Project.should_receive(:all).with(:conditions => {:client_group_id => client_group_ids},
            :limit => Project::NUMBER_OF_TOP_ACTIVE_PROJECTS, :order => "activity DESC").and_return @top_active
        end

        it "account as a worker" do
          @account = mock_model(Worker)
          @account.stub(:has_role?).with(Role::ADMIN).and_return false
          worker_groups = []
          (rand(10)+1).times do |i|
            worker_groups << mock_model(WorkerGroup, :id => i)
          end
          @account.stub(:worker_groups).and_return worker_groups
          worker_group_ids = @account.worker_groups.collect {|g| g.id}
          Project.should_receive(:all).with(:conditions => {:worker_group_id => worker_group_ids},
            :limit => Project::NUMBER_OF_TOP_ACTIVE_PROJECTS, :order => "activity DESC").and_return @top_active
        end

        after :each do
          Project.top_active_projects(@account).should == @top_active
        end
      end
    end

    it "#update_activity" do
      projects = []
      (rand(10+1)).times do
        project = mock_model(Project)
        activity = mock("activity")
        project.stub(:recalculate_activity).and_return activity
        project.should_receive(:update_attribute).with(:activity, project.recalculate_activity)
        projects << project
      end
      Project.stub(:all).and_return projects
      Project.update_activity
    end
  end

  describe "Instance methods" do
    before :each do
      @project = Project.new
    end

    it "#recalculate_activity" do
      task_activity = rand(100)
      Task.should_receive(:recent_count).with(@project.id).and_return task_activity
      request_activity = rand(100)
      @project.stub(:milestones).and_return mock("milestones")
      ClientRequest.should_receive(:recent_count).with(@project.milestones).and_return request_activity
      message_activity = rand(100)
      Message.should_receive(:recent_count).with(@project).and_return message_activity
      @project.recalculate_activity.should == task_activity + request_activity + message_activity;
    end

    describe "#allows_access?" do
      it "account is nil" do
        @project.allows_access?(nil).should be_false
      end

      it "account is an admin" do
        account = mock_model(Worker)
        account.stub(:has_role?).with(Role::ADMIN).and_return true
        @project.allows_access?(account).should be_true
      end

      it "account is an worker" do
        account = mock_model(Worker)
        account.stub(:has_role?).with(Role::ADMIN).and_return false
        worker_groups = []
        (rand(10)+1).times do |i|
          worker_groups << mock_model(WorkerGroup, :id => i)
        end
        account.stub(:worker_groups).and_return worker_groups
        worker_group_ids = account.worker_groups.collect {|g| g.id}
        @project.allows_access?(account).should == worker_group_ids.include?(@project.worker_group_id)
      end

      it "account is an worker" do
        account = mock_model(Client)
        client_groups = []
        (rand(10)+1).times do |i|
          client_groups << mock_model(ClientGroup, :id => i)
        end
        account.stub(:client_groups).and_return client_groups
        client_group_ids = account.client_groups.collect {|g| g.id}
        @project.allows_access?(account).should == client_group_ids.include?(@project.client_group_id)
      end
    end

    it "#workers" do
      worker_group = mock(WorkerGroup, :accounts => mock("accounts"))
      @project.stub(:worker_group).and_return worker_group
      @project.workers.should == worker_group.accounts
    end

    it "#total_billed_hours" do
      tasks = mock("tasks")
      @project.should_receive(:tasks).and_return tasks
      task_ids = mock("task_ids")
      tasks.should_receive(:all).with(:select => "id").and_return task_ids
      total_billed_hours = mock("total_billed_hours")
      BillableTime.should_receive(:sum).with("billed_hour", :conditions => {:task_id => task_ids}).and_return total_billed_hours
      @project.total_billed_hours.should == total_billed_hours
    end
  end
end


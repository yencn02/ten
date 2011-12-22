require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ClientRequest do
  describe "Class Methods" do
    describe "#get_priority_list" do
      it "should return priority list" do
        priority_list = []
        i = 1
        ClientRequest::PRIORITIES.each do |p|
          priority_list.push([p, i])
          i = i+1
        end
        ClientRequest.get_priority_list.should == priority_list
      end
    end

    it "#recent_count" do
      client_request_count = 0
      milestones = []
      (rand(10)+1).times do |i|
        milestone = mock_model(Milestone, :id => i)
        milestones << milestone
        count = rand(100)
        ClientRequest.should_receive(:count).and_return count
        client_request_count += count
      end
      ClientRequest.recent_count(milestones).should == client_request_count
    end

    it "#priority_value_for" do
      priority = mock("priority")
      index = mock("index")
      ClientRequest::PRIORITIES.should_receive(:index).with(priority).and_return index
      result = mock("result")
      index.should_receive(:+).with(1).and_return result
      ClientRequest.priority_value_for(priority).should == result
    end

    it "#priority_text_for" do
      priority = mock("priority")
      index = rand(ClientRequest::PRIORITIES.size)
      priority.should_receive(:-).with(1).and_return index
      ClientRequest.priority_text_for(priority).should == ClientRequest::PRIORITIES[index]
    end

    describe "#paginate_requests" do
      it "for all projects" do
        project = mock_model(Project)
        priority = "High"
        page = 1
        per_page = 3
        
        #priority_value = mock("priority_value")
        priority_value = ClientRequest.priority_value_for(priority)
        results = ClientRequest.joins(:milestone).paginate(
          :conditions => {"milestones.project_id" => project.id, :priority => priority_value},
          :page => page, :per_page => per_page)
        #ClientRequest.should_receive(:paginate).with(:joins => :milestone,
        #  :conditions => {"milestones.project_id" => project.id, :priority => priority_value},
        #  :page => page, :per_page => per_page).and_return results
        ClientRequest.paginate_requests(project.id, priority, page, per_page).should == results
      end

      it "for selected project" do
        project = mock_model(Project)
        priority = "all"
        page = 1
        per_page = 3
        #priority_value = ClientRequest.priority_value_for(priority)
        results = ClientRequest.joins(:milestone).paginate(
          :conditions => {"milestones.project_id" => project.id},
          :page => page, :per_page => per_page)
        ClientRequest.paginate_requests(project.id, priority, page, per_page).should == results
      end
      
    end
  end

  describe "Instance Methods" do
    before :each do
      @client_request = ClientRequest.new
    end
    
    describe "#total_billed_hours" do
      it "Should return total billed hours" do
        total_billed_hours = mock("total_billed_hours")
        @client_request.task.stub(:total_billed_hours).and_return total_billed_hours
        @client_request.total_billed_hours.should == total_billed_hours
      end
    end

    describe "#total_estimated_hours" do
      it "Should return total estimated hours" do
        estimated_hours = mock("hours")
        @client_request.task.stub(:estimated_hours).and_return estimated_hours
        @client_request.total_estimated_hours.should == estimated_hours
      end
    end

    describe "#allows_update?" do
      it "account is a Client" do
        account = Client.new
        result = mock("true or false")
        project = mock("project")
        project.stub(:allows_access?).with(account).and_return result
        @client_request.milestone.stub(:project).and_return project
        @client_request.allows_update?(account).should == result
      end

      it "account is a Admin" do
        account = Worker.new
        account.stub(:has_role?).with(Role::ADMIN).and_return true
        @client_request.allows_update?(account).should == true
      end

      it "account is a worker and no worker in list" do
        account = Worker.new
        account.stub(:has_role?).with(Role::ADMIN).and_return false
        @client_request.stub(:worker_list).and_return []
        @client_request.allows_update?(account).should == false
      end

      it "account is a leader" do
        account = Worker.new
        account.stub(:has_role?).with(Role::ADMIN).and_return false
        account.stub(:has_role?).with(Role::LEAD).and_return true
        worker_list = [mock("worker")]
        @client_request.stub(:worker_list).and_return worker_list
        worker_list.stub(:include?).with(account).and_return true
        @client_request.allows_update?(account).should == true
      end
      
    end

    describe "#has_right?" do
      before :each do
        @id = mock("id")
        @worker = mock("worker")
        Worker.should_receive(:find).with(@id).and_return @worker
      end
      it "account is a Admin" do
        @worker.stub(:has_role?).with(Role::ADMIN).and_return true
        @client_request.has_right?(@id).should == true
      end

      it "account is a worker and no worker in list" do
        @worker.stub(:has_role?).with(Role::ADMIN).and_return false
        @client_request.stub(:worker_list).and_return []
        @client_request.has_right?(@id).should == false
      end

      it "account is a leader" do
        @worker.stub(:has_role?).with(Role::ADMIN).and_return false
        worker_list = [mock("worker")]
        @client_request.stub(:worker_list).and_return worker_list
        worker_list.stub(:include?).with(@worker).and_return true
        @client_request.has_right?(@id).should == true
      end
    end

    it "#worker_list" do
      project = mock("project")
      @client_request.milestone.stub(:project).and_return project
      accounts = mock("accounts")
      worker_group  = mock("worker_group", :accounts => accounts)
      project.should_receive(:worker_group).and_return worker_group
      @client_request.worker_list.should == accounts
    end
  end#Instance Methods
  
end
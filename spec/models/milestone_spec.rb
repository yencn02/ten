require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Milestone do
  describe "Instance Methods" do
    before :each do
      @milestone = Milestone.new
    end

    describe "#due?" do
      it "should return false" do
        @milestone.stub(:due_date).and_return Time.now.next_month
        @milestone.due?.should be_false
      end

      it "should return true" do
        @milestone.stub(:due_date).and_return Time.now.ago(2.days)
        @milestone.due?.should be_true
      end
    end

    describe "#near?" do
      it "should return true" do
        @milestone.stub(:due_date).and_return(Date.today + $near_milestone.to_i - 1)
        @milestone.near?.should be_true
      end
      it "should return false" do
        @milestone.stub(:due_date).and_return(Date.today + $near_milestone.to_i + 1)
        @milestone.near?.should be_false
      end
      it "should return false" do
        @milestone.stub(:due_date).and_return(Date.today - 11)
        @milestone.near?.should be_false
      end
    end

    describe "#far?" do
      it "should return true" do
        @milestone.stub(:due_date).and_return(Date.today + $near_milestone.to_i + 5)
        @milestone.far?.should be_true
      end
      it "should return false" do
        @milestone.stub(:due_date).and_return(Date.today + $near_milestone.to_i - 5)
        @milestone.far?.should be_false
      end
    end

    it "#get_task_list" do
      tasks = []
      client_requests = []
      (rand(10)+1).times do
        task = mock_model(Task)
        client_requests << mock_model(ClientRequest, :task => task)
        tasks << task
      end
      @milestone.stub(:client_requests).and_return client_requests
      @milestone.get_task_list.should == tasks
    end

    it "#get_feature_list" do
      client_requests = []
      (rand(10)+1).times do
        client_requests << mock_model(ClientRequest)
      end
      @milestone.stub(:client_requests).and_return client_requests
      @milestone.get_feature_list.should == client_requests
    end
  end#Instance Methods

  describe "Class Methods" do
    describe "#milestone_by_due_date" do
      it "with nil project" do
        project_id = nil
        milestones = mock("List of milestones")
        Milestone.should_receive(:all).with(:order => "due_date ASC").and_return milestones
        Milestone.milestone_by_due_date(project_id).should == milestones
      end
      
      it "with selected project" do
        project_id = mock("project_id")
        milestones = mock("List of milestones")
        Milestone.should_receive(:all).with(:conditions => {:project_id => project_id}, :order => "due_date ASC").and_return milestones
        Milestone.milestone_by_due_date(project_id).should == milestones
      end
    end
  end#Class Methods

end
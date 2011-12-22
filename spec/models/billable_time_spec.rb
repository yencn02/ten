require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BillableTime do
  describe "Instance Methods" do
    before :each do
      @billable_time = BillableTime.new(:description => "description")
    end

    describe "#save_with_security_check" do
      before :each do
        @account = mock("account", :id => 1)
        @task = mock_model(Task, :id => 1)
        Task.stub(:find).with(@billable_time.task_id).and_return @task
      end
      
      it "should have permission to save" do
        @task.stub(:allows_access?).with(@account).and_return true
        result = mock("result")
        @billable_time.stub(:save).and_return result
        @billable_time.save_with_security_check(@account).should == result
      end

      it "should not have permission" do
        @task.stub(:allows_access?).with(@account).and_return false
        lambda{
          @billable_time.save_with_security_check(@account)
        }.should raise_error(SecurityError)
      end
    end

    describe "#validate" do
      it "should be false" do
        @billable_time.billed_hour = 0.24
        @billable_time.valid?.should be_false
      end

      it "should be true" do
        @billable_time.billed_hour = 0.25
        @billable_time.valid?.should be_true
      end
    end
  end
  
end
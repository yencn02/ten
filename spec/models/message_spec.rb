require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  describe "Class Methods" do
    describe "#developer_discussion_on_task" do
      it "should return developer messages on given task" do
        page = 1
        group = Factory(:worker_group)
        worker1 = Factory(:worker, :worker_groups => [group])
        worker2 = Factory(:worker, :worker_groups => [group])
        task = mock_model(Task)
        (1..3).each { Factory(:message, :task => task, :sender => worker1)}
        (1..5).each { Factory(:message, :task => task, :sender => worker2)}
        msgs = Message.developer_discussion_on_task(task.id, page)
        msgs.count.should == 8
      end

      it "should return messages in case of page -1" do
        page = 2
        group = Factory(:worker_group)
        worker1 = Factory(:worker, :worker_groups => [group])
        worker2 = Factory(:worker, :worker_groups => [group])
        task = mock_model(Task)
        (1..3).each { Factory(:message, :task => task, :sender => worker1)}
        (1..5).each { Factory(:message, :task => task, :sender => worker2)}
        msgs = Message.developer_discussion_on_task(task.id, page-1)
        Message.developer_discussion_on_task(task.id, page-1).should_not nil

#        page = mock("page")
#        per_page = mock("per_page")
#        task_id = mock("task_id")
#        Message.stub(:paginate).with(:joins => :sender, :page => page, :per_page => per_page,
#          :conditions => {"accounts.type" => "Worker", :task_id => task_id}, :order => 'created_at DESC').and_return []
#        result = mock("result")
#        Message.stub(:paginate).with(:joins => :sender, :page => page - 1, :per_page => per_page,
#          :conditions => {"accounts.type" => "Worker", :task_id => task_id}, :order => 'created_at DESC').and_return result
#        Message.developer_discussion_on_task(task_id, page).should == result
      end
    end
  end
end
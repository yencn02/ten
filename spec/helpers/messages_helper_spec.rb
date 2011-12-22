require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MessagesHelper do
  include MessagesHelper

  describe "#message_status" do
    it "#message_status for worker message" do
      @message = mock_model(Message, :task => mock_model(Task, :project => mock_model(Project, :name => "project_name")))
      @current_account = Worker.new
      @prefix =  "message"
      @project = @message.task.project.name
    end

    it "#message_status for client message" do
      @message = mock_model(ClientMessage, :client_request => mock_model(ClientRequest, :milestone => mock_model(Milestone, :project => mock_model(Project, :name => "project_name"))))
      @current_account = Client.new
      @prefix =  "client_message"
      @project = @message.client_request.milestone.project.name
    end

    after :each do
      msg_statuses = mock("msg_statuses")
      @message.should_receive(:status_for).with(@current_account).and_return msg_statuses
      message_status(@message, @current_account).should == [@project, @prefix, "#{msg_statuses}"]
    end
  end
end

describe Client::MessagesHelper do
  include Client::MessagesHelper

  describe "#status_message" do
    it "#status_message for worker message" do
      @message = mock_model(Message, :task => mock_model(Task, :project => mock_model(Project, :name => "project_name")))
      @current_account = Worker.new
      @prefix =  "message"
      @project = @message.task.project.name
    end

    it "#status_message for client message" do
      @message = mock_model(ClientMessage, :client_request => mock_model(ClientRequest, :milestone => mock_model(Milestone, :project => mock_model(Project, :name => "project_name"))))
      @current_account = Client.new
      @prefix =  "client_message"
      @project = @message.client_request.milestone.project.name
    end

    after :each do
      msg_statuses = mock("msg_statuses")
      @message.should_receive(:status_for).with(@current_account).and_return msg_statuses
      msg_statuses.should_receive(:+).with("_status").and_return msg_statuses
      status_message(@message, @current_account).should == [@prefix, @project, msg_statuses]
    end
  end
end
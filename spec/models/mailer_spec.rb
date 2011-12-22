require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mailer do
  it "#client_request_message" do
    #message = mock("message", :body => "body")
    message = mock("message", :body => "body")
    Message.stub!(:find).and_return message
    milestone = mock_model(Milestone)
    Milestone.stub!(:find).and_return milestone
    client_request = mock_model(ClientRequest, :milestone => milestone, :title => "title",:show_client_request_path=>"path")
    message.stub!(:client_request).and_return client_request
    project = mock_model(Project, :name => "project name")
    milestone.should_receive(:project).twice.and_return project
    clients = Array.new {mock_model(Client)}
    project.should_receive(:clients).and_return clients
    sender = mock("sender",:name=>"sender name")
    message.stub!(:sender).and_return sender
  
    Mailer.deliver_client_request_message(message)
  end

  it "#task_message" do
    task = mock(task,:id=>1,:worker => mock("worker", :email => mock("email")),:title=>"title",:project_id =>1,:status=>"status")
    message = mock(message, :task => task, :body => "message body",:sender =>mock("sender",:name =>"name"))
    project = mock("project",:id =>1, :name => "project name",:workers =>Array.new {mock("worker")})
    task.stub!(:project).and_return project
    client_request = mock("client_request", :title => "client_request title")
    task.stub!(:client_request).and_return client_request
    Mailer.task_message(message)
  end
end
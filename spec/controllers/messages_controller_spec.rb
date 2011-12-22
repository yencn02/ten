require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe MessagesController, "GET index" do
  before(:each) do
    @worker = login_as_worker
    @messages = []
    @client_messages = []
    controller.stub!(:current_account).and_return @worker
  end
  it "should get TOP messages" do
    (0..2).each { |i| @messages << mock_model(Message, :created_at => Time.now - i.day)}
    @worker.should_receive(:top_messages).and_return @messages
    @worker.stub!(:top_client_messages).and_return []
    get :index
    msgs = assigns[:messages]
    (0..2).each do |i|
      msgs[i].should == @messages[i]
    end
  end
  it "should get TOP client messages" do
    (0..4).each { |i| @client_messages << mock_model(ClientMessage, :created_at => Time.now - i.day)}
    @worker.should_receive(:top_client_messages).and_return @client_messages
    @worker.stub!(:top_messages).and_return []
    get :index
    msgs = assigns[:messages]
    (0..4).each do |i|
      msgs[i].should == @client_messages[i]
    end    
  end
  it "should sort messages by sent date" do
    (0..2).each { |i| @messages << mock_model(Message, :created_at => Time.now - i.day)}
    (3..5).each { |i| @client_messages << mock_model(ClientMessage, :created_at => Time.now - i.day)}
    (6..8).each { |i| @messages << mock_model(Message, :created_at => Time.now - i.day)}
    @worker.should_receive(:top_messages).and_return @messages
    @worker.should_receive(:top_client_messages).and_return @client_messages
    get :index
    msgs = assigns[:messages]
    (0..2).each do |i|
      msgs[i].should == @messages[i]      
    end
    (3..5).each do |i|
      msgs[i].should == @client_messages[i-3]            
    end
    (6..8).each do |i|
      msgs[i].should == @messages[i-3]            
    end
  end
end

describe MessagesController, "GET list" do
  before(:each) do
    @worker = login_as_worker
    @messages = []
    @client_messages = []
    controller.stub!(:current_account).and_return @worker
    (0..2).each { |i| @messages << mock_model(Message, :created_at => Time.now - i.day)}
    (3..5).each { |i| @client_messages << mock_model(ClientMessage, :created_at => Time.now - i.day)}
  end
  describe "should get message base on status" do
    it "should get READ and UNREAD messages is status is not given" do
      @worker.should_receive(:top_messages).and_return @messages
      @worker.should_receive(:top_client_messages).and_return @client_messages
      get :list, :status =>  "ALL"  
      assigns[:messages].size.should == 6
    end
    it "should get READ messages if status is read" do
      @worker.should_receive(:read_messages).and_return @messages
      @worker.should_receive(:read_client_messages).and_return @client_messages
      get :list, :status => MessageStatus::READ      
    end
    it "should get UNREAD messages if status is unread"  do
      @worker.should_receive(:unread_messages).and_return @messages
      @worker.should_receive(:unread_client_messages).and_return @client_messages
      get :list, :status => MessageStatus::UNREAD      
    end
    it "should get ARCHIVE messages if status is archived" do
      @worker.should_receive(:archived_messages).and_return @messages
      @worker.should_receive(:archived_client_messages).and_return @client_messages
      get :list, :status => MessageStatus::ARCHIVED      
    end
  end

  it "should render index template" do
    @worker.stub!(:read_messages).and_return @messages
    @worker.stub!(:read_client_messages).and_return @client_messages
    get :list, :status => MessageStatus::READ
    response.should render_template(:index)
  end
  
end

describe MessagesController do
  before :each do
    @current_account = login_as_worker
  end

  describe "#show" do
    it "should be done" do
      id = "1"
      message = mock_model(Message, :status => "unread", :task => mock_model(Task))
      Message.should_receive(:find).with(id).and_return message
      message.should_receive(:set_status).with(@current_account.id, MessageStatus::READ)
      message.should_receive(:save).and_return true
      get :show, :id => id
      response.should redirect_to edit_task_path(message.task)
    end
  end

  describe "#read_message" do
    it "should read worker message" do
      params = {:id => "1", :type => "message"}
      message = mock_model(Message, :task => mock_model(Task))
      Message.should_receive(:find).with(params[:id]).and_return message
      Message.should_receive(:set_status).with(@current_account.id, params[:id], MessageStatus::READ)
      get :read_message, :id => params[:id], :type => params[:type]
      response.should redirect_to task_path(message.task)
    end

    it "should read client message" do
      params = {:id => "1"}
      client_message = mock_model(ClientMessage, :client_request => mock_model(ClientRequest, :task => mock_model(Task)))
      ClientMessage.should_receive(:find).with(params[:id]).and_return client_message
      ClientMessage.should_receive(:set_status).with(@current_account.id, params[:id], ClientMessageStatus::READ)
      get :read_message, :id => params[:id]
      response.should redirect_to task_path(client_message.client_request.task)
    end
  end

  describe "#update_status" do
    it "should update status for messages" do
      params = {:message_ids => mock("message_ids"), :read => "read"}
      status  = params[:read]
      message_ids = params[:message_ids]
      Message.should_receive(:set_status).with(@current_account.id, message_ids, status)
      get :update_status, :read => params[:read], :message_ids => params[:message_ids]
    end

    it "should update status for client messages" do
      params = {:client_message_ids => mock("client_message_ids"), :read => "read"}
      status  = params[:read]
      client_message_ids = params[:client_message_ids]
      ClientMessage.should_receive(:set_status).with(@current_account.id, client_message_ids, status)
      get :update_status, :read => params[:read], :client_message_ids => params[:client_message_ids]
    end

    after :each do
      response.should redirect_to list_messages_path
    end
  end
end

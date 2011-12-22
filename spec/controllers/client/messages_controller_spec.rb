require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Client::MessagesController, "GET list" do
  before(:each) do
    @current_account = login_as_client
    controller.stub!(:current_account).and_return @current_account
  end

  describe "#index" do
    it "should be done" do
      controller.should_receive(:list)
      get :index
      response.should render_template :list
    end
  end

  describe "#list" do
    it "MessageStatus::READ" do
      @status = MessageStatus::READ
      @messages = mock("List of messages")
      @current_account.should_receive(:read_client_messages).and_return @messages
      @messages.should_receive(:sort!)
      get :list, :status => @status
    end

    it "MessageStatus::UNREAD" do
      @status = MessageStatus::UNREAD
      @messages = mock("List of messages")
      @current_account.should_receive(:unread_client_messages).and_return @messages
      @messages.should_receive(:sort!)
      get :list, :status => @status
    end

    it "MessageStatus::ARCHIVED" do
      @status = MessageStatus::ARCHIVED
      @messages = mock("List of messages")
      @current_account.should_receive(:archived_client_messages).and_return @messages
      @messages.should_receive(:sort!)
      get :list, :status => @status
    end

    it "all" do
      @status = "all"
      @messages = mock("List of messages")
      @current_account.should_receive(:all_client_messages).and_return @messages
      @messages.should_receive(:sort!)
      get :list, :status => @status
    end

    after :each do
      flash[:information].should == "List of #{@status} messages"
    end
  end

  describe "#read_message" do
    it "should be done" do
      id = "1"
      client_message = mock(ClientMessage, :client_request => mock_model(ClientRequest))
      ClientMessage.should_receive(:find_by_id).with(id).and_return client_message
      ClientMessage.should_receive(:set_status).with(@current_account.id, id, ClientMessageStatus::READ)
      get :read_message, :id => id
      response.should redirect_to client_request_path(client_message.client_request)
    end
  end

  describe "#update_status" do
    it "should not update" do
      params = {:read => "read", :client_message_ids => mock("client_message_ids")}
      number_update = 0
      ClientMessage.should_receive(:set_status).with(@current_account.id, params[:client_message_ids], params[:read]).and_return number_update
      get :update_status, :read => params[:read], :client_message_ids => params[:client_message_ids]
      flash[:notice].should == "The selected messages haven't been updated status"
    end

    it "status is archived" do
      params = {:read => "archived", :client_message_ids => mock("client_message_ids")}
      number_update = 2
      ClientMessage.should_receive(:set_status).with(@current_account.id, params[:client_message_ids], params[:read]).and_return number_update
      get :update_status, :read => params[:read], :client_message_ids => params[:client_message_ids]
      #flash[:notice].should == "The selected messages have been archived"
    end

    it "status is not archived" do
      params = {:read => "read", :client_message_ids => mock("client_message_ids")}
      number_update = 2
      ClientMessage.should_receive(:set_status).with(@current_account.id, params[:client_message_ids], params[:read]).and_return number_update
      get :update_status, :read => params[:read], :client_message_ids => params[:client_message_ids]
      #flash[:notice].should == "The selected messages have been updated status"
    end
    
    after :each do
      response.should redirect_to list_client_messages_path
    end
  end
end 



require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ClientMessage do
  describe "set and get status for client message" do
    before(:each) do      
        @client_group = Factory(:client_group)
        @worker_group = Factory(:worker_group)
        project = Factory(:project, :client_group => @client_group, :worker_group => @worker_group)
        @client_request = Factory(:client_request, :milestone => Factory(:milestone, :project => project)) 
        
        @clients = []
        @workers = []
        (1..3).each { @clients << Factory(:client, :client_groups => [@client_group])}
        (1..3).each { @workers << Factory(:worker, :worker_groups => [@worker_group])}
        @msg = Factory(:client_message, :client_request => @client_request, :sender => @clients[0])        
      end
    describe "apply status to all clients in sender group" do  
      it "should set client message to UNREAD if status is unread" do
        ClientMessage.init_message_status(@msg, ClientMessageStatus::UNREAD )
        @msg.client_message_statuses.count.should == 6
        (0..5).each do |i|
#          @msg.client_message_statuses[i].account.should == @clients[i]         
          @msg.client_message_statuses[i].status.should == ClientMessageStatus::UNREAD
        end    
      end  
      
      it "should set client message to READ if status is read" do
        ClientMessage.init_message_status(@msg, ClientMessageStatus::READ )
        @msg.client_message_statuses.count.should == 6
        (0..5).each do |i|
          #@msg.client_message_statuses[i].account.should == @clients[i]
          @msg.client_message_statuses[i].status.should == ClientMessageStatus::READ
        end    
      end   
      
      it "should set client message to ARCHIVED if status is archived" do
        ClientMessage.init_message_status(@msg, ClientMessageStatus::ARCHIVED )
        @msg.client_message_statuses.count.should == 6
        (0..5).each do |i|
#          @msg.client_message_statuses[i].account.should == @clients[i]
          @msg.client_message_statuses[i].status.should == ClientMessageStatus::ARCHIVED
        end    
      end  
      
      it "should set status to UNREAD by default" do
        ClientMessage.init_message_status(@msg)
        @msg.client_message_statuses.count.should == 6
        (0..5).each do |i|
#          @msg.client_message_statuses[i].account.should == @clients[i]
          @msg.client_message_statuses[i].status.should == ClientMessageStatus::UNREAD
        end    
      end            
    end
    
    describe "should set status for all messages of a user" do
      before(:each) do      
        @client1 = Factory(:client, :client_groups => [@client_group])
        @client2 = Factory(:client, :client_groups => [@client_group])      
        (1..3).each {        
          msg = Factory(:client_message, :client_request => @client_request, :sender => @client1) 
          ClientMessage.init_message_status(msg)
        }
      end
      it "update all message of a user in a group" do 
        message_ids = ClientMessage.find(:all).map {|t| t.id}           
        ClientMessage.set_status(@client1, message_ids, ClientMessageStatus::READ).should == 3
      end    
    end
    
    describe "get status message for a user" do
      before(:each) do
        @client = Factory(:client, :client_groups => [@client_group])
        @msg = Factory(:client_message, :client_request => @client_request, :sender => @client) 
      end
      
      it "status message is unread" do              
        ClientMessage.init_message_status(@msg)
        @msg.status_for(@client).should == "unread"
      end
      
      it "status message is read" do        
        ClientMessage.init_message_status(@msg, ClientMessageStatus::READ )
        @msg.status_for(@client).should == "read"
      end
      
      it "status message is archived" do       
        ClientMessage.init_message_status(@msg, ClientMessageStatus::ARCHIVED)
        @msg.status_for(@client).should == "archived"
      end      
    end
    
  end

  it "#client_discussion_on_task" do
    page = 1
    client_request = mock_model(ClientRequest)
    result = mock("result")
    result = ClientMessage.paginate(:joins => :sender, :page => page, :per_page => 3,
      :conditions => {:client_request_id => client_request.id}, :order => 'created_at DESC')
    ClientMessage.client_discussion_on_task(client_request.id, page).should == result
  end
  
end

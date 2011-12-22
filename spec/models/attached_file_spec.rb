require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttachedFile do
  describe "Instance Methods" do
    before :each do 
      @attached_file = AttachedFile.new
    end
  end

  describe "Class Methods" do 
    it "paginate_by_client_request" do 
      client_request_id = 1
      page = 1
      attached_files = mock_model(AttachedFile)
      attached_files = AttachedFile.order("created_at DESC").page(page).per(3).where("client_request_id =?", client_request_id)
      #AttachedFile.should_receive(:paginate_by_client_request).with(:page => page, :per_page => 3,
      #  :conditions => {:client_request_id => client_request_id}, :order => 'created_at DESC').and_return attached_files
      AttachedFile.paginate_by_client_request(client_request_id, page).should == attached_files
    end

    it "paginate_by_task" do
      task = mock_model(Task)
      page = 1
      attached_files = mock_model(AttachedFile)
      attached_files = AttachedFile.order("created_at DESC").page(page).per(3).where("task_id =?", task.id)
      AttachedFile.paginate_by_task(task.id, page).should == attached_files
    end
    
    describe "delete_client_request_file" do 
      before :each do 
        @id = mock("id")
        @account = mock("account")
        file = mock_model(AttachedFile, :client_request_id => 1)
        AttachedFile.should_receive(:find).with(@id).and_return file
        @client_request = mock_model(ClientRequest)
        ClientRequest.should_receive(:find).with(file.client_request_id).and_return @client_request
      end

      it "should have permission" do
        @client_request.stub(:allows_update?).with(@account).and_return true
        AttachedFile.should_receive(:delete).with(@id)
        AttachedFile.delete_client_request_file(@id, @account)
      end

      it "should not have permission" do 
        @client_request.stub(:allows_update?).with(@account).and_return false
        lambda{
          AttachedFile.delete_client_request_file(@id, @account)
        }.should raise_error(SecurityError)
      end

    end
  end
end
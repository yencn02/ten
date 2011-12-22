require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe AttachedFilesController do
  before(:each) do
    @current_account = login_as_client
    controller.should_receive(:menu).and_return mock("menu")
  end

  describe "#attach" do
    before :each do
      @id_suffix = "__client_request"
      @params = {:uploaded_data => mock("uploaded_data"),
        "fileNote#{@id_suffix}" => mock("file note"),
        "rid#{@id_suffix}" => "1",
        "tid#{@id_suffix}" => "1"
      }
      @attached_file = mock_model(AttachedFile, :task_id => 1, :client_request_id => 1)
      #AttachedFile.should_receive(:new).with(:uploaded_data => @params["attachedFile#{@id_suffix}"]).and_return @attached_file
      AttachedFile.stub!(:new,:uploaded_data => @params["attachedFile#{@id_suffix}"]).and_return @attached_file
      @attached_file.should_receive(:description=).with(@params["fileNote#{@id_suffix}"])
      @attached_file.should_receive(:client_request_id=).with(@params["rid#{@id_suffix}"].to_i)
      @attached_file.should_receive(:task_id=).with(@params["tid#{@id_suffix}"])
    end

    it "should attach file successfully" do
      @attached_file.should_receive(:save).and_return true
      @attached_file.should_receive(:errors).and_return []
      attached_files = mock("List of attached files with pagination", :empty? => false,
        :current_page => 1, :each => nil, :first => @attached_file, :total_pages => 1)
      AttachedFile.should_receive(:paginate_by_client_request).with(@attached_file.client_request_id, nil).and_return attached_files
      AttachedFile.should_receive(:paginate_by_task).with(@attached_file.task_id, nil).and_return attached_files
      post :attach, :uploaded_data => @params[:uploaded_data], "fileNote#{@id_suffix}" => @params["fileNote#{@id_suffix}"],
        "rid#{@id_suffix}" => @params["rid#{@id_suffix}"], "tid#{@id_suffix}" => @params["tid#{@id_suffix}"]
    end

    it "should attach file unsuccessfully" do
      @attached_file.should_receive(:save).and_return false
      post :attach, :uploaded_data => @params[:uploaded_data], "fileNote#{@id_suffix}" => @params["fileNote#{@id_suffix}"],
        "rid#{@id_suffix}" => @params["rid#{@id_suffix}"], "tid#{@id_suffix}" => @params["tid#{@id_suffix}"]
    end

  end

  describe "#set_file_description" do
    it "it should be done" do
      params = {:id => "1", :value => "description"}
      file = mock_model(AttachedFile)
      AttachedFile.should_receive(:find).with(params[:id]).and_return file
      file.should_receive(:description=).with(params[:value])
      file.should_receive(:save).and_return true
      file.should_receive(:description).and_return params[:value]
      get :set_file_description, :id => params[:id], :value => params[:value]
      response.body.should == params[:value]
    end
  end

  describe "#paginate" do
    it "should be done for client request" do
      page = "1"
      client_request_id = "1"
      id_suffix = "__client_request"
      attached_files = Array.new
      AttachedFile.should_receive(:paginate_by_client_request).with(client_request_id, page).and_return attached_files
      get :paginate, :afp => page, :rid => client_request_id, :id_suffix => id_suffix
      response.should render_template "attached_files/_file_list"
    end

    it "should be done for task" do
      page = "1"
      task_id = "1"
      id_suffix = "__task"
      attached_files = Array.new
      AttachedFile.should_receive(:paginate_by_task).with(task_id, page).and_return attached_files
      get :paginate, :afp => page, :tid => task_id, :id_suffix => id_suffix
      response.should render_template "attached_files/_file_list"
    end
  end

  describe "#delete" do
    it "should delete file for client request" do
      @params = {:id => "1"}
      file = mock_model(AttachedFile, :task_id => nil, :client_request_id => 1)
      file2 = mock_model(AttachedFile, :task_id => nil, :client_request_id => 1)
      AttachedFile.should_receive(:find).with(@params[:id]).and_return file
      file.should_receive(:destroy)
      attached_files = mock("List of attached files with pagination", :empty? => false,
        :current_page => 1, :each => nil, :first => file2, :total_pages => 1)
      AttachedFile.should_receive(:paginate_by_client_request).with(file.client_request_id, 1).and_return attached_files
      get :delete, :id => @params[:id]
    end

    it "should delete file for technical note" do
      @params = {:id => "1"}
      file = mock_model(AttachedFile, :task_id => 1, :client_request_id => nil)
      file2 = mock_model(AttachedFile, :task_id => 1, :client_request_id => nil)
      AttachedFile.should_receive(:find).with(@params[:id]).and_return file
      file.should_receive(:destroy)
      attached_files = mock("List of attached files with pagination", :empty? => false,
        :current_page => 1, :each => nil, :first => file2, :total_pages => 1)
      AttachedFile.should_receive(:paginate_by_task).with(file.task_id, 1).and_return attached_files
      get :delete, :id => @params[:id]
    end

  end

end


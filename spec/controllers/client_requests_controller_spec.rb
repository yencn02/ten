# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe ClientRequestsController do
  before(:each) do
    @current_account = login_as_manager
    #For menu
    Project.stub!(:paginate_by_activity).with(@current_account, "active", nil)
  end

  describe "#index" do
    it "should get all client requests" do
      @current_account.stub(:project_ids).and_return [1,2,3]
      @client_request =  mock_model(ClientRequest)
      ClientRequest.stub!(:find).and_return(@client_request)
      ClientRequest.stub!(:paginate_requests).with(@current_account.project_ids,
        "all", 1, 15).and_return @client_requests
      get :index
      assigns[:client_requests].should == @client_requests

    end

    it "should get client requests by selected project" do
      client_requests = mock_model(ClientRequest)
      project = mock_model(Project)
      Project.should_receive(:find).with(1).and_return project
      ClientRequest.stub!(:paginate_requests).with(1,
        "all", 1, 15).and_return client_requests
      get :index, :project_id => 1, :priority => "all", :page => 1
      session[:active_project].should_not be_nil
      assigns[:client_requests].should == client_requests
      response.should render_template :index
    end

  end

  describe "#new" do
    it "has no seleced project " do
      id = nil
      get :new
      session[:project_id].should be_nil
      flash[:notice].should == "Please select a project"
    end

    it "has seleced project " do
      id = "1"
      project = mock_model(Project, :id => id.to_i)
      Project.should_receive(:find_by_id).with(id, @current_account).and_return project
      client_request = mock_model(ClientRequest)
      ClientRequest.should_receive(:new).and_return client_request
      get :new, :id => id
      session[:project_id].should == project.id
      assigns[:client_request].should == client_request
    end

  end

  describe "#create" do
    before :each do
      @params = {:client_request => mock_model(ClientRequest), :project_id => 1}
      @project = mock_model(Project, :id => 1)
      @client_request = mock_model(ClientRequest, :id => 1, :title => "title",
        :milestone => mock_model(Milestone, :project => @project)
      )
      session[:active_project] = @project.id     
      ClientRequest.stub!(:new).with(@params[:client_request]).and_return @client_request
      @client_request.stub!(:status=).with("new")
    end

    it "should create unsuccessfully" do
     
      @client_request.stub!(:save).and_return false
      #Project.should_receive(:find_by_id).with(session[:active_project], @current_account).and_return @project
      #post :create, :client_request => @params[:client_request], :attached_files => @params[:attached_files]
      controller.stub!(:create)
    end

    it "should create successfully" do
      client_request = mock_model(ClientRequest,:id =>1,:title => "title",
        :milestone => mock_model(Milestone, :project => @project),:description =>"description")
      controller.stub!(:create).with(:client_request=>client_request)
    
    end
  end

  describe "#show" do
    it "should be done" do
      params = {:id => "1", :page => "1"}
      client_request = mock_model(ClientRequest, :id => params[:id].to_i)
      ClientRequest.should_receive(:first).with(:conditions => { :id => params[:id].to_i}).and_return client_request
      client_msg = mock("List of client message with pagination")
      ClientMessage.should_receive(:client_discussion_on_task).with(client_request.id, params[:page]).and_return client_msg
      client_request_changes = mock("List of client request changes with pagination")
      ClientRequestChange.should_receive(:paginate_by_client_request).with(client_request.id, nil).and_return client_request_changes
      attached_files = mock("List of attached files with pagination")
      AttachedFile.should_receive(:paginate_by_client_request).with(client_request.id, nil).and_return attached_files
      get :show, :id => params[:id], :page => params[:page]
    end
  end

end


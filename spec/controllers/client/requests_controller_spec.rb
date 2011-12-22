# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Client::RequestsController do
  before(:each) do
    @current_account = login_as_client
    projects = mock("projects")
    Project.stub!(:paginate_by_activity).with(@current_account, "active", nil).and_return projects
    #controller.stub!(:current_account).and_return @current_account
  end

  describe "#index" do
    it "should get all project" do
      page = 1
      params_project_id = "all"
      params_priority = mock("priority")
      client_requests = mock("List all client request with pagination")
      @current_account.stub(:project_ids).and_return [1,2,3]
      ClientRequest.should_receive(:paginate_requests).with(@current_account.project_ids,
        params_priority, page, Client::RequestsController::PER_PAGE).and_return client_requests
      get :index, :project_id => params_project_id, :priority => params_priority, :page => page
      session[:active_project].should be_nil
      assigns[:client_requests].should == client_requests
      response.should render_template :index
    end

    it "should get selected project" do
      page = 1
      params_project_id = "1"
      params_priority = mock("priority")
      client_requests = mock("List all client request with pagination")
      project = mock_model(Project)
      Project.should_receive(:find).with(params_project_id).and_return project
      ClientRequest.should_receive(:paginate_requests).with(params_project_id,
        params_priority, page, Client::RequestsController::PER_PAGE).and_return client_requests
      get :index, :project_id => params_project_id, :priority => params_priority, :page => page
      session[:active_project].should_not be_nil
      assigns[:client_requests].should == client_requests
      response.should render_template :index
    end

  end

  describe "#new" do
    it "has no seleced project " do
      id = nil
      project= mock_model(Project)
      Project.stub!(:find).and_return project
      session[:active_project]=project.id
      login_as_lead
      get :new
      session[:project_id].should be_nil
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
      @params = {:client_request => mock("ClientRequest attributes"), :project_id => 1}
      @client_request = mock_model(ClientRequest, :id => 1, :title => "title",
        :milestone => mock_model(Milestone, :project => mock_model(Project, :id => 1))
      )
      ClientRequest.stub!(:find).and_return @client_request
  #    @client_request.should_receive(:status=).with("new")
    end

    it "should create unsuccessfully" do
      login_as_client
      session[:active_project]= @client_request.milestone.project
      @client_request.stub!(:save).and_return false
      controller.stub(:create)
    end

    it "should create successfully" do
      login_as_client
      session[:active_project]= @client_request.milestone.project
      controller.stub(:create)
      @client_request.stub!(:save).and_return true
    end
  end


  describe "#new_change" do
    before :each do
      @params = {:description => '<br mce_bogus="1">change description', :client_request_id => "1"}
      @client_request_change = mock_model(ClientRequestChange, :client_request_id => 1, :id => 1)
      ClientRequestChange.should_receive(:new).with(
        :description => @params[:description].to_s.gsub('<br mce_bogus="1">', ""),
        :client_request_id => @params[:client_request_id]).and_return @client_request_change
    end

    it "should save change successfully" do
      @client_request_change.should_receive(:save).and_return true
      @client_request_change.should_receive(:errors).and_return []
      @client_request_changes = mock("List of client request changes", {
          :empty? => false, :current_page => 1, :each => 1,
          :first => @client_request_change, :total_pages => 1
        })
      ClientRequestChange.should_receive(:paginate_by_client_request).with(
        @client_request_change.client_request_id, 1).and_return @client_request_changes
      get :new_change, :description => @params[:description], :client_request_id => @params[:client_request_id]
      response.body.should =~ /ClientRequestChange.afterSave/
      response.body.should =~ /changeList/
      response.body.should =~ /highlight/
    end

    it "should save change unsuccessfully" do
      @client_request_change.should_receive(:save).and_return false
      get :new_change, :description => @params[:description], :client_request_id => @params[:client_request_id]
      response.body.should =~ /ClientRequestChange.bindCreateChangeBtn/
      response.body.should =~ /#newChangeError/
    end

  end

  describe "#delete_change" do
    it "should delete a change successfully" do
      params = {:id => "1", :rcp => "1"}
      change = mock_model(ClientRequestChange, :client_request_id => 1)
      ClientRequestChange.should_receive(:find_by_id_with_security_check).with(params[:id], @current_account).and_return change
      change.should_receive(:destroy)
      client_request_changes = Array.new
      ClientRequestChange.should_receive(:paginate_by_client_request).with(change.client_request_id, params[:rcp].to_i).and_return client_request_changes
      get :delete_change, :id => params[:id], :rcp => params[:rcp]
      response.body.should =~ /fade/
      response.body.should =~ /changeList/
      response.body.should =~ /ClientRequestChange.bindCreateChangeBtn/
    end
  end

  describe "#paginate_changes" do
    it "should be done" do
      page = "1"
      client_request_id = "1"
      client_request_changes = mock("List of client request changes")
      ClientRequestChange.should_receive(:paginate_by_client_request).with(client_request_id, page).and_return client_request_changes
      controller.should_receive(:readonly?).with(@current_account).and_return false
      get :paginate_changes, :rcp => page, :rid => client_request_id
      response.should render_template "client/requests/_change_list"
    end
  end

  describe "set_change_description" do
    it "it should be done" do
      params = {:id => "1", :value => "description"}
      change = mock_model(ClientRequestChange)
      ClientRequestChange.should_receive(:find).with(params[:id]).and_return change
      change.should_receive(:description=).with(params[:value])
      change.should_receive(:save).and_return true
      change.should_receive(:description).and_return params[:value]
      get :set_change_description, :id => params[:id], :value => params[:value]
      response.body.should == params[:value]
    end
  end

  describe "#show" do
    it "should be done" do
      params = {:id => "1", :page => "1"}
      client_request = mock_model(ClientRequest, :id => params[:id].to_i)
      ClientRequest.should_receive(:first).with(:conditions => { :id => params[:id].to_i}).and_return client_request
      controller.should_receive(:readonly?).with(@current_account).and_return false
      client_msg = mock("List of client message with pagination")
      ClientMessage.should_receive(:client_discussion_on_task).with(client_request.id, params[:page]).and_return client_msg
      client_request_changes = mock("List of client request changes with pagination")
      ClientRequestChange.should_receive(:paginate_by_client_request).with(client_request.id, nil).and_return client_request_changes
      attached_files = mock("List of attached files with pagination")
      AttachedFile.should_receive(:paginate_by_client_request).with(client_request.id, nil).and_return attached_files
      get :show, :id => params[:id], :page => params[:page]
    end
  end

  describe "#update_state_and_priority" do
    before :each do
      @params = {:id => "1", :client_request => mock("client_request attributes")}
      @client_request = mock_model(ClientRequest, {:id => @params[:id].to_i, :milestone => mock_model(Milestone, :project_id => 1)})
      ClientRequest.should_receive(:find).with(@params[:id]).and_return @client_request
    end

    it "should be successed" do
      @client_request.should_receive(:update_attributes!).with(@params[:client_request]).and_return true
      post :update_state_and_priority, :id => @params[:id], :client_request => @params[:client_request]
      response.should  redirect_to list_requests_by_project_path(:project_id => @client_request.milestone.project_id)
    end

    it "should be unsuccessed" do
      @client_request.should_receive(:update_attributes!).with(@params[:client_request]).and_return false
      post :update_state_and_priority, :id => @params[:id], :client_request => @params[:client_request]
      response.should render_template(:show)
      flash[:notice].should == "Error when updating request"
    end

  end
end

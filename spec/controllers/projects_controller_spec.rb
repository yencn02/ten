require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"

describe ProjectsController do
  before(:each) do
    @current_account = login_as_manager
  end

  describe "#index" do
    it "should redirect to :active" do
      get :index
      response.should redirect_to :action => "active"
    end
  end

  describe "#list all projects" do
    it "#active" do
      projects = mock("List of projects")
      Project.should_receive(:paginate).with(:page => 1, :per_page => 10, :conditions => {:status => Project::ACTIVE}).and_return projects
      get :active
      assigns(:projects).should == projects
      response.should render_template(:index)
    end

    it "inactive" do
      page = "3"
      status = "inactive"
      projects = mock("List of projects")
      Project.should_receive(:paginate).with(:page => page, :per_page => 10, :conditions => {:status => Project::INACTIVE}).and_return projects
      get :inactive, :page => page
      assigns(:projects).should == projects
      response.should render_template(:index)
    end
  end

  describe "#create" do
    it "successfully" do
     # params_project = {"these" => "all project info"}
     @project = Factory.create(:project)
     Project.stub!(:find).and_return @project
     controller.stub!(:create).with(:project => @project)
     Project.find(@project.id).nil?.should_not be true
    end

    it "unsuccessfully" do
      params_project = {"these" => "all project info"}
      project = mock_model(Project, :status => "inactive")
      Project.should_receive(:new).with(params_project).and_return project
      project.should_receive(:save).and_return false

      post :create, :project => params_project
      response.should render_template /#facebox #errorExplanation/
    end
  end

  describe "#edit" do
    it "prepare data for the edit page" do
      id = "1"
      project = mock_model(Project)
      client_groups = mock("All client groups")
      worker_groups = mock("All worker groups")
      Project.should_receive(:find).with(id).and_return project
      ClientGroup.should_receive(:all).and_return client_groups
      WorkerGroup.should_receive(:all).and_return worker_groups
      get :edit, :id => id
      assigns(:project).should == project
      assigns(:client_groups).should == client_groups
      assigns(:worker_groups).should == worker_groups
      response.should render_template(:edit)
    end
  end

  describe "#update" do
    it "update successfully" do
      id = "1"
      params_project = {"these" => "project info"}
      project = mock_model(Project)
      Project.should_receive(:find).with(id).and_return(project)
      project.should_receive(:update_attributes).with(params_project).and_return true
      put :update, :id => id, :project => params_project
      response.body.should == "window.location.reload();"
    end

    it "update unsuccessfully" do
      id = "1"
      params_project = {"these" => "project info"}
      project = mock_model(Project)
      Project.should_receive(:find).with(id).and_return(project)
      project.should_receive(:update_attributes).with(params_project).and_return false
      put :update, :id => id, :project => params_project
      response.should render_template /#facebox #errorExplanation/
    end
  end

  describe "#destroy" do
    it "successfully" do
      id = "1"
      status = "active"
      project = mock_model(Project, :status => status)
      Project.should_receive(:find).with(id).and_return(project)
      project.should_receive(:destroy)
      delete :destroy, :id => id
      flash[:info] = "A project has been removed successfully."
      response.should redirect_to "/projects/#{status}"
    end

    it "unsuccessfully" do
      id = "1"
      status = "active"
      Project.should_receive(:find).with(id).and_return nil
      delete :destroy, :id => id
      flash[:notice] = "No project that fit ID: \"#{id}\" to delete."
      response.should redirect_to :action => "index"
    end
  end

  describe "#new" do
    it "should render successfully" do
      project = mock_model(Project)
      Project.should_receive(:new).and_return project
      client_groups = mock("All client groups")
      worker_groups = mock("All worker groups")
      ClientGroup.should_receive(:all).and_return client_groups
      WorkerGroup.should_receive(:all).and_return worker_groups
      get :new
      assigns[:project].should == project
      assigns[:client_groups].should == client_groups
      assigns[:worker_groups].should == worker_groups
      response.should render_template(:new)
    end
  end


  describe "#show" do
    it "should render successfully" do
      id = "1"
      project = mock_model(Project)
      Project.should_receive(:find).with(id).and_return project
      get :show, :id => id
      assigns[:project].should == project
      response.should render_template(:show)
    end
  end

  describe "#paginate" do
    before :each do
      @params = {:page => "1"}
      @projects = mock("List of projects with pagination")
      Project.should_receive(:paginate_by_activity).with(@current_account , "active", @params[:page]).and_return @projects
    end

    it "should render navbar_milestone template" do
      @params[:type] = "milestone"
      get :paginate, :type => @params[:type], :page => "1"
      response.should render_template "projects/_navbar_milestone"
    end

    it "should render navbar_request template" do
      @params[:type] = "request"
      get :paginate, :type => @params[:type], :page => "1"
      response.should render_template "projects/_navbar_request"
    end

    it "should render navbar_client_request template" do
      @params[:type] = "client_request"
      get :paginate, :type => @params[:type], :page => "1"
      response.should render_template "projects/_navbar_client_request"
    end

    it "should render navbar_task template" do
      @params[:type] = "task"
      get :paginate, :type => @params[:type], :page => "1"
      response.should render_template "projects/_navbar_task"
    end

    it "should render navbar_timesheet" do
      @params[:type] = "timesheet"
      get :paginate, :type => @params[:type], :page => "1"
      response.should render_template "projects/_navbar_timesheet"
    end

  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe TimesheetsController do
  before(:each) do
    @current_account = login_as_manager
  end

  describe "#index" do
    it "should be done" do
      get :index
      response.should redirect_to :action => :projects
    end
  end

  describe "#projects" do
    it "should be done" do
      Project.should_receive(:paginate_by_activity).with(@current_account , "active", 1, TimesheetsController::PER_PAGE)
      get :projects
    end
  end

  describe "#workers" do
    it "should be done" do
      Worker.should_receive(:paginate_by_activity).with(@current_account, 1, TimesheetsController::PER_PAGE)
      get :workers
    end
  end

  describe "#list_by_project" do
    before :each do
      #For menu
      Project.should_receive(:paginate_by_activity).with(@current_account, "active", nil)
    end

    it "all projects" do
      Task.should_receive(:paginate).with(:page => 1, :per_page => TimesheetsController::PER_PAGE)
      get :list_by_project, :project_id => "all"
      session[:active_project].should be_nil
    end

    it "with selected project" do
      project_id = "1"
      project = mock_model(Project, :id => 1)
      Project.should_receive(:find).with(project_id).and_return project
      Task.should_receive(:paginate).with(:conditions => ["project_id =?", project_id], :page => 1, :per_page => TimesheetsController::PER_PAGE)
      get :list_by_project, :project_id => project_id
      session[:active_project].should == project.id
    end
  end

  describe "#list_by_worker" do
    before :each do
      #For menu
      Worker.should_receive(:paginate_by_activity).with(@current_account, nil)
    end
    it "all workers" do
      Task.should_receive(:paginate).with(:page => 1, :per_page => TimesheetsController::PER_PAGE)
      get :list_by_worker, :project_id => "all"
    end

    it "with selected worker" do
      worker_id = "1"
      worker = mock_model(Worker, :id => 1)
      Worker.should_receive(:find).with(worker_id).and_return worker
      Task.should_receive(:paginate).with(:conditions => ["worker_id =?", worker_id], :page => 1, :per_page => TimesheetsController::PER_PAGE)
      get :list_by_worker, :worker_id => worker_id
    end
  end

  describe "#create" do
    before :each do
      @params = {:description => "description", :billed_hour => "4", :task_id => "1"}
      @billable_time = mock_model(BillableTime)
      BillableTime.should_receive(:new).and_return @billable_time
      @billable_time.should_receive(:description=).with(@params[:description])
      @billable_time.should_receive(:billed_hour=).with(@params[:billed_hour])
      @billable_time.should_receive(:task_id=).with(@params[:task_id])
    end

    it "create successfully" do
      @billable_time.should_receive(:save_with_security_check).with(@current_account).and_return true
      @billable_time.should_receive(:errors).and_return []
      post :create, :description => @params[:description], :task_id => @params[:task_id], :billed_hour => @params[:billed_hour]
      flash[:info].should == "Timesheet create successful!"
      response.body.should =~ /window.location.reload()/
    end

    it "create unsuccessfully" do
      @billable_time.should_receive(:save_with_security_check).with(@current_account).and_return false
      post :create, :description => @params[:description], :task_id => @params[:task_id], :billed_hour => @params[:billed_hour]
    end

  end

end

require "spec_helper"
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Admin::WorkersController do
  before(:each) do
    login_as_admin
  end
  context "#index" do
    it "should be successful" do
      get :index
      response.should be_success
      assigns[:title_view].should == "Administration - Worker Management"
    end
    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end

    it "should return list of worker with pagination" do
      page = 1
      workers = mock("Something")
      Worker.should_receive(:paginate).with(:page => page, :per_page => 10).and_return workers
      get :index
      assigns(:workers).should == workers
    end
  end
  context "#new" do
    it "should be successful" do
      get :new
      response.should be_success
      assigns[:title_view].should == "Administration - Worker Management"
    end
    it "should render the index template" do
      get :new
      response.should render_template(:new)
    end

    it "prepare data for the new page" do
      worker = mock("A Worker")
      Worker.should_receive(:new).and_return worker
      companies = mock("List of companies")
      Company.should_receive(:all).with(:include => :worker_groups).and_return companies
      roles = mock("List of roles")
      Role.should_receive(:worker_roles).and_return roles
      get :new
      assigns(:worker).should == worker
      assigns(:companies).should == companies
      assigns(:roles).should == roles
    end
  end
  context "#edit" do
    it "prepare data for the edit page" do
      worker_id = 1
      worker_group = mock_model(WorkerGroup, {:company_id => 1, :id => 1})
      role = mock_model(Role, {:id => 1})
      worker = mock_model(Worker, {
          :id => worker_id.to_i,
          :worker_groups => [worker_group],
          :roles => [role]
        })
      Worker.should_receive(:find).with(worker_id).and_return worker
#      params[:worker_] = {
#        :company => worker.worker_groups[0].company_id,
#        :group => worker.worker_groups[0].id,
#        :role => worker.roles[0].id
#      }
      companies = mock("Some companies")
      Company.should_receive(:all).with(:include => :worker_groups).and_return companies
      roles = mock("Some roles")
      Role.should_receive(:worker_roles).and_return roles
      get :edit, :id => worker_id
      assigns(:worker).should == worker
      assigns(:companies).should == companies
      assigns(:roles).should == roles
      response.should be_success
      response.should render_template(:edit)
      assigns[:title_view].should == "Administration - Worker Management"
    end
  end

  context "#update" do
    it "successfully" do
      params_worker = {"name" => "hehe1", "login" => "hehe2"}
      params_worker_ = {}
      id = "1"

      worker = mock_model(Worker, :id => id.to_i)
      Worker.stub(:find).with(id).and_return worker

      companies = mock("List of companies")
      Company.should_receive(:all).with(:include => :worker_groups).and_return companies
      roles = mock("List of roles")
      Role.should_receive(:worker_roles).and_return roles
      worker.should_receive(:update_attributes).with(params_worker)
      worker.should_receive(:save).and_return true
      path = "/admin/workers/#{id}"
      worker.stub(:admin_worker_path).and_return path
      put :update, :id => id, :worker => params_worker, :worker_ => params_worker_
      flash[:info].should == 'Worker was updated successfully.'
      response.should redirect_to(path)
    end

    it "should update role successfully" do
      params_worker = {"name" => "hehe1", "login" => "hehe2"}
      params_worker_ = {"role" => "1"}
      id = "1"

      worker = mock_model(Worker, :id => id.to_i)
      Worker.stub(:find).with(id).and_return worker

      companies = mock("List of companies")
      Company.should_receive(:all).with(:include => :worker_groups).and_return companies
      roles = mock("List of roles")
      Role.should_receive(:worker_roles).and_return roles

      role = mock_model(Role, :id => params_worker_["role"].to_i)
      Role.stub(:find).with(params_worker_["role"]).and_return role
      worker.stub(:roles=).with([role])

      worker.should_receive(:update_attributes).with(params_worker)
      worker.should_receive(:save).and_return true
      path = "/admin/workers/#{id}"
      worker.stub(:admin_worker_path).and_return path

      put :update, :id => id, :worker => params_worker, :worker_ => params_worker_
      flash[:info].should == 'Worker was updated successfully.'
      response.should_not render_template(:edit)
      response.should redirect_to(path)
    end
    it "unsuccessfully with empty name" do
      params_worker = {"name" => "", "login" => "hehe2"}
      params_worker_ = {}
      id = "1"

      worker = mock_model(Worker, :id => id.to_i)
      Worker.stub(:find).with(id).and_return worker

      companies = mock("List of companies")
      Company.should_receive(:all).with(:include => :worker_groups).and_return companies
      roles = mock("List of roles")
      Role.should_receive(:worker_roles).and_return roles
      worker.should_receive(:update_attributes).with(params_worker)
      worker.should_receive(:save).and_return false
      put :update, :id => id, :worker => params_worker, :worker_ => params_worker_
      flash[:info].should be_nil
      response.should render_template(:edit)
    end
  end

  describe "#show" do
    it "prepare data for the show page" do
      id = "1"
      session[:account_id] = 100
      worker = mock_model(Worker)
      Worker.should_receive(:find).with(id).and_return worker
      dynamic_bottom_menu_items = mock("Something")
      controller.should_receive(:worker_dynamic_mnu_items).with(id, session[:account_id]).and_return dynamic_bottom_menu_items
      get :show, :id => id
      assigns(:worker).should == worker
      assigns[:dynamic_bottom_menu_items].should == dynamic_bottom_menu_items
      response.should be_success
      response.should render_template(:show)
      assigns[:title_view].should == "Administration - Worker Management"
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created worker" do
        params_worker = {
          "address"=>"123 Main st, Brooklyn NY 11215",
          "name"=>"asdfads",
          "password_confirmation"=>"123456",
          "phone"=>"123-123-1232",
          "description"=>"Just a test worker from Brooklyn",
          "link"=>"http://testlink.com",
          "password"=>"123456", "enabled" => true,
          "login"=>"test_worker", "type" => "Worker",
          "email"=>"test_worker@tenhq.com"}
        params_worker_ = {"role" => "1", "group" => "1"}

        companies = mock("List of companies")
        Company.should_receive(:all).with(:include => :worker_groups).and_return companies
        roles = mock("List of roles")
        Role.should_receive(:worker_roles).and_return roles
        worker = mock_model(Worker)
        Worker.should_receive(:new).with(params_worker).and_return worker

        role = mock_model(Role  )
        Role.should_receive(:find).with(params_worker_["role"]).and_return role
        worker.stub(:roles=).with([role])

        worker_group = mock_model(WorkerGroup, :id => params_worker_["group"].to_i)
        WorkerGroup.stub(:find).with(params_worker_["group"]).and_return worker_group
        worker.stub(:worker_groups=).with([worker_group])

        worker.should_receive(:save).and_return true

        post :create, :worker => params_worker, :worker_ => params_worker_
        flash[:info].should == "A worker has been created successfully."
        response.should redirect_to :action => "new"
      end
    end
    describe "with invalid params" do
      it "empty name and password" do
        params_worker = {
          "address"=>"123 Main st, Brooklyn NY 11215",
          "name"=>"",
          "password_confirmation"=>"",
          "phone"=>"123-123-1232",
          "description"=>"Just a test worker from Brooklyn",
          "link"=>"http://testlink.com",
          "password"=>"123456", "enabled" => true,
          "login"=>"test_worker", "type" => "Worker",
          "email"=>"test_worker@tenhq.com"}
        params_worker_ = {"role" => "1", "group" => "1"}

        companies = mock("List of companies")
        Company.should_receive(:all).with(:include => :worker_groups).and_return companies
        roles = mock("List of roles")
        Role.should_receive(:worker_roles).and_return roles
        worker = mock_model(Worker)
        Worker.should_receive(:new).with(params_worker).and_return worker

        role = mock_model(Role  )
        Role.should_receive(:find).with(params_worker_["role"]).and_return role
        worker.stub(:roles=).with([role])

        worker_group = mock_model(WorkerGroup, :id => params_worker_["group"].to_i)
        WorkerGroup.stub(:find).with(params_worker_["group"]).and_return worker_group
        worker.stub(:worker_groups=).with([worker_group])

        worker.should_receive(:save).and_return false

        post :create, :worker => params_worker, :worker_ => params_worker_
        flash[:info].should be_nil
        response.should_not redirect_to :action => "new"
      end
      it "empty no group, no role chose" do
        params_worker = {
          "address"=>"123 Main st, Brooklyn NY 11215",
          "name"=>"fsdfs",
          "password_confirmation"=>"sdfasd",
          "phone"=>"123-123-1232",
          "description"=>"Just a test worker from Brooklyn",
          "link"=>"http://testlink.com",
          "password"=>"123456", "enabled" => true,
          "login"=>"test_worker", "type" => "Worker",
          "email"=>"test_worker@tenhq.com"}
        params_worker_ = {}

        companies = mock("List of companies")
        Company.should_receive(:all).with(:include => :worker_groups).and_return companies
        roles = mock("List of roles")
        Role.should_receive(:worker_roles).and_return roles
        worker = mock_model(Worker)
        Worker.should_receive(:new).with(params_worker).and_return worker

        worker.should_receive(:save).and_return false

        post :create, :worker => params_worker, :worker_ => params_worker_
        flash[:info].should be_nil
        response.should_not redirect_to :action => "new"
      end
    end
  end

  describe "#destroy" do
    it "successful" do
      params_id = "1"
      worker = mock_model(Worker, :id => params_id, :enabled => true)
      Worker.should_receive(:find_by_id).with(params_id).and_return worker
      worker.should_receive(:destroy)
      delete :destroy, :id => params_id
      response.should redirect_to admin_workers_path
    end

    it "unsuccessful" do
      id = "1"
      Worker.should_receive(:find_by_id).with(id).and_return nil
      delete :destroy, :id => id
      flash[:notice].should == "No workers that fit ID: \"#{id}\" to remove."
      response.should redirect_to admin_workers_path
    end

  end

  describe "#confirm" do
    it " successful" do
      params_id = "1"
      worker = mock_model(Worker, :id => params_id)
      Worker.should_receive(:find_by_id).with(params_id).and_return worker
      get :confirm, :id => params_id
      assigns[:title_view].should == "Administration - Confirmation"
      response.should render_template(:confirm)
    end

    it "unsuccessful" do
      id = "1"
      Worker.should_receive(:find_by_id).with(id).and_return nil
      get :confirm, :id => id
      flash[:notice].should == "No workers that fit ID: \"#{id}\" to remove."
      response.should redirect_to admin_workers_path
    end

  end
  
end


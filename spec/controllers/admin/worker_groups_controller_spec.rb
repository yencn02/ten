require "spec_helper"
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Admin::WorkerGroupsController do

  before(:each) do
    login_as_admin
  end
  context "#index" do
    it "should be successful" do
      get :index
      response.should be_success
      assigns[:title_view].should == "Administration - Worker group Management"
    end
    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end

    it "should return list of Worker groups with pagination" do
      page = 1
      groups = mock("Something")
      WorkerGroup.should_receive(:paginate).with(
        :page => page, :per_page => 10,
        :include => :company, :order => "created_at DESC").and_return groups
      get :index
      assigns(:worker_groups).should == groups
    end
  end
  context "#new" do
    it "should be successful" do
      get :new
      response.should be_success
      assigns[:title_view].should == "Administration - Worker group Management"
    end
    it "should render the index template" do
      get :new
      response.should render_template(:new)
    end

    it "prepare data for the new page" do
      companies = mock("List of Worker companies")
      Company.should_receive(:all).and_return companies

      group = mock_model(WorkerGroup)
      WorkerGroup.should_receive(:new).and_return group
      get :new
      assigns(:companies).should == companies
      assigns(:worker_group).should == group
    end
  end

  context "#edit" do
    it "prepare data for the edit page" do

      worker_group_id = "1"

      companies = mock("List of Worker companies")
      Company.should_receive(:all).and_return companies

      group = mock_model(WorkerGroup)

      WorkerGroup.should_receive(:find).with(worker_group_id).and_return group
      get :edit, :id => worker_group_id
      assigns(:companies).should == companies
      assigns(:worker_group).should == group
      response.should be_success
      response.should render_template(:edit)
      assigns[:title_view].should == "Administration - Worker group Management"
    end
  end

  context "#update" do
    it "update group info successfully" do
      params_group = {"name" => "hehe1", "description" => "hehe2"}
      id = "1"

      group = mock_model(WorkerGroup, :id => id.to_i)
      WorkerGroup.stub(:find).with(id).and_return group

      group.should_receive(:update_attributes).with(params_group)
      group.should_receive(:save).and_return true
      path = "/admin/worker_groups/#{id}"
      group.stub(:admin_worker_group_path).and_return path
      put :update, :id => id, :worker_group => params_group
      flash[:info].should == 'A worker group has been updated successfully.'
      response.should redirect_to(path)
    end
    it "update group info unsuccessfully" do
      params_group = {"name" => "", "description" => "hehe2"}
      id = "1"
      group = mock_model(WorkerGroup, :id => id.to_i)
      WorkerGroup.stub(:find).with(id).and_return group

      group.should_receive(:update_attributes).with(params_group)
      group.should_receive(:save).and_return false
      put :update, :id => id, :worker_group => params_group
      response.should render_template(:edit)
    end

    it "add Workers to group successfully" do
      params_accounts = ["1"]
      id = "1"
      params_action_type = "add"

      group = mock_model(WorkerGroup, :id => id.to_i, :accounts => [mock_model(Worker)])
      WorkerGroup.stub(:find).with(id).and_return group

      workers = [mock_model(Worker), mock_model(Worker)]
      Worker.should_receive(:find).with(params_accounts).and_return workers

      workers.each{|worker|
        group.accounts << worker if group.accounts.include?(worker)
      }
      group.should_receive(:save).and_return true
      path = "/admin/worker_groups/#{id}"
      group.stub(:admin_worker_group_path).and_return path
      put :update, :id => id, :accounts => params_accounts, :action_type => params_action_type
      flash[:info].should == 'A worker group has been updated successfully.'
      response.should redirect_to(path)
    end

    it "remove Workers out of group successfully" do
      params_accounts = ["1"]
      id = "1"
      params_action_type = "remove"

      group = mock_model(WorkerGroup, :id => id.to_i, :accounts => [mock_model(Worker, :id => 1), mock_model(Worker, :id => 2)])
      WorkerGroup.stub(:find).with(id).and_return group

      accounts = []
      group.accounts.each{|worker|
        accounts << worker if !params_accounts.include?(worker.id.to_s)
      }
      group.should_receive(:accounts=).with(accounts)

      group.should_receive(:save).and_return true
      path = "/admin/worker_groups/#{id}"
      group.stub(:admin_worker_group_path).and_return path
      put :update, :id => id, :accounts => params_accounts, :action_type => params_action_type
      flash[:info].should == 'A worker group has been updated successfully.'
      response.should redirect_to(path)
    end

  end

  describe "#show" do
    it "prepare data for the show page" do
      id = "1"

      group = mock_model(WorkerGroup, :id => id.to_i)
      WorkerGroup.stub(:find).with(id, :include => :accounts).and_return group

      get :show, :id => id

      assigns(:worker_group).should == group

      response.should be_success
      response.should render_template(:show)

      assigns[:title_view].should == "Administration - Worker group Management"
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created Worker company" do
        params_group = {
          "name"=>"hehe1",
          "description"=>"hehe2",
        }

        group = mock_model(WorkerGroup)
        WorkerGroup.should_receive(:new).with(params_group).and_return group

        group.should_receive(:save).and_return true

        post :create, :worker_group => params_group
        flash[:info].should == "A worker group has been created successfully."
        response.should redirect_to :action => "new"
      end
    end
    describe "with invalid params" do
      it "name is empty" do
        params_group = {
          "name"=>"",
          "description"=>"hehe2",
        }

        group = mock_model(WorkerGroup)
        WorkerGroup.should_receive(:new).with(params_group).and_return group

        group.should_receive(:save).and_return false

        post :create, :worker_group => params_group
        response.should_not redirect_to :action => "new"
      end
    end
  end

  describe "#confirm" do
    it "should be successful" do
      get :confirm, :id => "1"
      response.should be_success
      assigns[:title_view].should == "Administration - Worker group Management"
      response.should render_template(:confirm)
    end
    it "prepare data" do
      id = "1"
      group = mock_model(WorkerGroup, :name => "My name")
      WorkerGroup.stub(:find_by_id).with(id).and_return group

      get :confirm, :id => "1"

      assigns[:worker_group].should == group
    end

    it "Worker group could not be found" do
      id = "1"
      WorkerGroup.stub(:find_by_id).with(id).and_return nil

      get :confirm, :id => id
      flash[:notice].should == "No worker groups that fit ID: \"#{id}\""
      assigns[:worker_group].should be_nil
    end
  end

  describe "#destroy" do
    it "successfully" do
      id = "1"
      group = mock_model(WorkerGroup)
      WorkerGroup.stub(:find_by_id).with(id).and_return group
      group.should_receive(:destroy)
      delete :destroy, :id => id
      response.should redirect_to admin_worker_groups_path
    end

    it "unsuccessfully" do
      id = "1"
      WorkerGroup.stub(:find_by_id).with(id).and_return nil
      delete :destroy, :id => id
      flash[:notice].should == "No worker groups that fit ID: \"#{id}\""
      response.should render_template(:confirm)
    end
  end

  describe "#add_Worker" do
    it "workers that already in group will not in added candidates" do
      id = "1"
      group = mock_model(WorkerGroup, :accounts => [mock_model(Worker, :id => 1), mock_model(Worker, :id => 2)])
      WorkerGroup.stub!(:find_by_id).with(id).and_return group
      candidate_workers = mock_model(Worker)
      Worker.stub!(:find).and_return candidate_workers

      get :add_worker, :id => id
      assigns[:candidate_workers].should == []
    end

    it "no Workers in group" do
      id = "1"
      candidate_workers = mock_model(Worker)
      group = mock_model(WorkerGroup, :accounts => [])
      WorkerGroup.stub(:find_by_id).with(candidate_workers.id).and_return group
      Worker.stub!(:find).with(:all).and_return candidate_workers
      get :add_worker, :id => candidate_workers.id
      response.should render_template(:add_worker)
    end

    it "group not be found" do
      id = "1"
      WorkerGroup.stub(:find_by_id).with(id).and_return nil
      get :add_worker, :id => id
      flash[:notice].should == "No worker groups that fit ID: \"#{id}\""
      response.should render_template(:add_worker)
    end
  end

  describe "#remove_worker" do
    it "successfully" do
      id = "1"
      group = mock_model(WorkerGroup, :accounts => mock("List of Workers in group"))
      WorkerGroup.stub(:find_by_id).with(id).and_return group

      get :remove_worker, :id => id
      assigns(:worker_group).should == group
      assigns(:workers).should == group.accounts
    end

    it "unsuccessfully" do
      id = "1"
      WorkerGroup.stub(:find_by_id).with(id).and_return nil
      get :remove_worker, :id => id
      flash[:notice].should == "No worker groups that fit ID: \"#{id}\""
      response.should render_template(:remove_worker)
    end
  end
end

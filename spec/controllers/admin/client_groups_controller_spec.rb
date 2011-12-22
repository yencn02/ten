require "spec_helper"
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Admin::ClientGroupsController do

  before(:each) do
    login_as_admin
  end
  context "#index" do
    it "should be successful" do
      get :index
      response.should be_success
      assigns[:title_view].should == "Administration - Client group Management"
    end
    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end

    it "should return list of client groups with pagination" do
      page = 1
      groups = mock("Something")
      ClientGroup.should_receive(:paginate).with(
        :page => page, :per_page => 10,
        :include => :client_company, :order => "created_at DESC").and_return groups
      get :index
      assigns(:client_groups).should == groups
    end
  end
  context "#new" do
    it "should be successful" do
      get :new
      response.should be_success
      assigns[:title_view].should == "Administration - Client group Management"
    end
    it "should render the index template" do
      get :new
      response.should render_template(:new)
    end

    it "prepare data for the new page" do
      companies = mock("List of client companies")
      ClientCompany.should_receive(:all).and_return companies

      group = mock_model(ClientGroup)
      ClientGroup.should_receive(:new).and_return group
      get :new
      assigns(:companies).should == companies
      assigns(:client_group).should == group
    end
  end
  
  context "#edit" do
    it "prepare data for the edit page" do
      
      client_group_id = "1"
      
      companies = mock("List of client companies")
      ClientCompany.should_receive(:all).and_return companies

      group = mock_model(ClientGroup)

      ClientGroup.should_receive(:find).with(client_group_id).and_return group
      get :edit, :id => client_group_id
      assigns(:companies).should == companies
      assigns(:client_group).should == group
      response.should be_success
      response.should render_template(:edit)
      assigns[:title_view].should == "Administration - Client group Management"
    end
  end

  context "#update" do
    it "update group info successfully" do
      params_group = {"name" => "hehe1", "description" => "hehe2"}
      id = "1"

      group = mock_model(ClientGroup, :id => id.to_i)
      ClientGroup.stub(:find).with(id).and_return group

      group.should_receive(:update_attributes).with(params_group)
      group.should_receive(:save).and_return true
      path = "/admin/client_groups/#{id}"
      group.stub(:admin_client_group_path).and_return path
      put :update, :id => id, :client_group => params_group
      flash[:info].should == 'A client group has been updated successfully.'
      response.should redirect_to(path)
    end
    it "update group info unsuccessfully" do
      params_group = {"name" => "", "description" => "hehe2"}
      id = "1"
      group = mock_model(ClientGroup, :id => id.to_i)
      ClientGroup.stub(:find).with(id).and_return group

      group.should_receive(:update_attributes).with(params_group)
      group.should_receive(:save).and_return false
      put :update, :id => id, :client_group => params_group
      response.should render_template(:edit)
    end

    it "add clients to group successfully" do
      params_accounts = ["1"]
      id = "1"
      params_action_type = "add"
      
      group = mock_model(ClientGroup, :id => id.to_i, :accounts => [mock_model(Client)])
      ClientGroup.stub(:find).with(id).and_return group

      clients = [mock_model(Client), mock_model(Client)]
      Client.should_receive(:find).with(params_accounts).and_return clients

      clients.each{|client|
        group.accounts << client if group.accounts.include?(client)
      }
      group.should_receive(:save).and_return true
      path = "/admin/client_groups/#{id}"
      group.stub(:admin_client_group_path).and_return path
      put :update, :id => id, :accounts => params_accounts, :action_type => params_action_type
      flash[:info].should == 'A client group has been updated successfully.'
      response.should redirect_to(path)
    end

    it "remove clients out of group successfully" do
      params_accounts = ["1"]
      id = "1"
      params_action_type = "remove"

      group = mock_model(ClientGroup, :id => id.to_i, :accounts => [mock_model(Client, :id => 1), mock_model(Client, :id => 2)])
      ClientGroup.stub(:find).with(id).and_return group

      accounts = []
      group.accounts.each{|client|
        accounts << client if !params_accounts.include?(client.id.to_s)
      }
      group.should_receive(:accounts=).with(accounts)

      group.should_receive(:save).and_return true
      path = "/admin/client_groups/#{id}"
      group.stub(:admin_client_group_path).and_return path
      put :update, :id => id, :accounts => params_accounts, :action_type => params_action_type
      flash[:info].should == 'A client group has been updated successfully.'
      response.should redirect_to(path)
    end
    
  end

  describe "#show" do
    it "prepare data for the show page" do
      id = "1"

      group = mock_model(ClientGroup, :id => id.to_i)
      ClientGroup.stub(:find).with(id).and_return group

      get :show, :id => id

      assigns(:client_group).should == group

      response.should be_success
      response.should render_template(:show)

      assigns[:title_view].should == "Administration - Client group Management"
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created client company" do
        params_group = {
          "name"=>"hehe1",
          "description"=>"hehe2",
        }

        group = mock_model(ClientGroup)
        ClientGroup.should_receive(:new).with(params_group).and_return group

        group.should_receive(:save).and_return true

        post :create, :client_group => params_group
        flash[:info].should == "A client group has been created successfully."
        response.should redirect_to :action => "new"
      end
    end
    describe "with invalid params" do
      it "name is empty" do
        params_group = {
          "name"=>"",
          "description"=>"hehe2",
        }

        group = mock_model(ClientGroup)
        ClientGroup.should_receive(:new).with(params_group).and_return group

        group.should_receive(:save).and_return false

        post :create, :client_group => params_group
        response.should_not redirect_to :action => "new"
      end
    end
  end

  describe "#confirm" do
    it "should be successful" do
      get :confirm, :id => "1"
      response.should be_success
      assigns[:title_view].should == "Administration - Client group Management"
      response.should render_template(:confirm)
    end
    it "prepare data" do
      id = "1"
      group = mock_model(ClientGroup)
      ClientGroup.stub(:find_by_id).with(id).and_return group

      get :confirm, :id => "1"

      assigns[:client_group].should == group
    end

    it "client group could not be found" do
      id = "1"
      ClientGroup.stub(:find_by_id).with(id).and_return nil

      get :confirm, :id => id
      flash[:notice].should == "No client groups that fit ID: \"#{id}\""
      assigns[:client_group].should be_nil
    end
  end

  describe "#destroy" do
    it "successfully" do
      id = "1"
      group = mock_model(ClientGroup)
      ClientGroup.stub(:find_by_id).with(id).and_return group
      group.should_receive(:destroy)
      delete :destroy, :id => id
      response.should redirect_to admin_client_groups_path
    end

    it "unsuccessfully" do
      id = "1"
      ClientGroup.stub(:find_by_id).with(id).and_return nil
      delete :destroy, :id => id
      flash[:notice].should == "No client groups that fit ID: \"#{id}\""
      response.should render_template(:confirm)
    end
  end

  describe "#add_client" do
    it "clients that already in group will not in added candidates" do
      id = "1"
      group = mock_model(ClientGroup, :accounts => [mock_model(Client, :id => 1), mock_model(Client, :id => 2)])
      ClientGroup.stub(:find_by_id).with(id).and_return group

      non_candidate_clients = group.accounts
      non_candidate_client_ids = non_candidate_clients.map{|x| x.id}
      candidate_clients = mock("List of candidate clients")
      Client.stub!(:find).with(:all, :conditions => ["id not in(?)", non_candidate_client_ids]).and_return candidate_clients

      get :add_client, :id => id
      response.should render_template(:add_client)
    end

    it "no clients in group" do
      id = "1"
      group = mock_model(ClientGroup, :accounts => [])
      ClientGroup.stub(:find_by_id).with(id).and_return group

      candidate_clients = mock("List of candidate clients")
      Client.stub!(:find).with(:all).and_return candidate_clients

      get :add_client, :id => id
      response.should render_template(:add_client)
    end

    it "group not be found" do
      id = "1"
      ClientGroup.stub(:find_by_id).with(id).and_return nil
      get :add_client, :id => id
      flash[:notice].should == "No client groups that fit ID: \"#{id}\""
      response.should render_template(:add_client)
    end
  end

  describe "#remove_client" do
    it "successfully" do
      id = "1"
      group = mock_model(ClientGroup, :accounts => mock("List of clients in group"))
      ClientGroup.stub(:find_by_id).with(id).and_return group

      get :remove_client, :id => id
      assigns(:client_group).should == group
      assigns(:clients).should == group.accounts
    end

    it "unsuccessfully" do
      id = "1"
      ClientGroup.stub(:find_by_id).with(id).and_return nil
      get :remove_client, :id => id
      flash[:notice].should == "No client groups that fit ID: \"#{id}\""
      response.should render_template(:remove_client)
    end
  end
end

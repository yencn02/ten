require "spec_helper"
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Admin::ClientsController do

  before(:each) do
    login_as_admin
  end
  context "#index" do
    it "should be successful" do
      get :index
      response.should be_success
      assigns[:title_view].should == "Administration - Client Management"
    end
    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end

    it "should return list of worker with pagination" do
      page = 1
      clients = mock("Something")
      Client.should_receive(:paginate).with(:page => page, :per_page => 10).and_return clients
      get :index
      assigns(:clients).should == clients
    end
  end
  context "#new" do
    it "should be successful" do
      get :new
      response.should be_success
      assigns[:title_view].should == "Administration - Client Management"
    end
    it "should render the index template" do
      get :new
      response.should render_template(:new)
    end

    it "prepare data for the new page" do
      client = mock("A Client")
      Client.should_receive(:new).and_return client
      companies = mock("List of companies")
      ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies
      get :new
      assigns(:client).should == client
      assigns(:companies).should == companies
    end
  end
  context "#edit" do
    it "prepare data for the edit page" do
      client_id = 1
      client_group = mock_model(ClientGroup, {:client_company_id => 1, :id => 1})
      client = mock_model(Client, {
          :id => client_id.to_i,
          :client_groups => [client_group],
        })
      Client.should_receive(:find).with(client_id).and_return client
#      params[:client_] = {
#        :company => client.client_groups[0].client_company_id,
#        :group => client.client_groups[0].id
#      }
      companies = mock("Some companies")
      ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies
      get :edit, :id => client_id
      assigns(:client).should == client
      assigns(:companies).should == companies
      response.should be_success
      response.should render_template(:edit)
      assigns[:title_view].should == "Administration - Client Management"
    end
  end

  context "#update" do
    it "successfully" do
      params_client = {"name" => "hehe1", "login" => "hehe2"}
      params_client_ = {}
      id = "1"

      client = mock_model(Client, :id => id.to_i)
      Client.stub(:find).with(id).and_return client

      companies = mock("List of companies")
      ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies
      client.should_receive(:update_attributes).with(params_client)
      client.should_receive(:save).and_return true
      path = "/admin/clients/#{id}"
      client.stub(:admin_client_path).and_return path
      put :update, :id => id, :client => params_client, :client_ => params_client_
      flash[:info].should == 'Client was updated successfully.'
      response.should redirect_to(path)
    end
    it "should update group successfully" do
      params_client = {"name" => "hehe1", "login" => "hehe2"}
      params_client_ = {"group" => "1"}
      id = "1"

      client = mock_model(Client, :id => id.to_i)
      Client.stub(:find).with(id).and_return client

      companies = mock("List of companies")
      ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies

      client_group = mock_model(ClientGroup, :id => params_client_["group"].to_i)
      ClientGroup.stub(:find).with(params_client_["group"]).and_return client_group
      client.stub(:client_groups=).with([client_group])

      client.should_receive(:update_attributes).with(params_client)
      client.should_receive(:save).and_return true
      path = "/admin/client/#{id}"
      client.stub(:admin_client_path).and_return path

      put :update, :id => id, :client => params_client, :client_ => params_client_
      flash[:info].should == 'Client was updated successfully.'
      response.should_not render_template(:edit)
      response.should redirect_to(path)
    end
    it "unsuccessfully with empty name" do
      params_client = {"name" => "", "login" => "hehe2"}
      params_client_ = {}
      id = "1"

      client = mock_model(Client, :id => id.to_i)
      Client.stub(:find).with(id).and_return client

      companies = mock("List of companies")
      ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies
      client.should_receive(:update_attributes).with(params_client)
      client.should_receive(:save).and_return false
      put :update, :id => id, :client => params_client, :client_ => params_client_
      flash[:notice].should be_nil
      response.should render_template(:edit)
    end
  end

  describe "#show" do
    it "prepare data for the show page" do
      id = 1
      client = mock_model(Client)
      Client.stub(:find).and_return client
      get :show, :id => id
      assigns(:client).should == client
      response.should be_success
      response.should render_template(:show)
      assigns[:title_view].should == "Administration - Client Management"
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created worker" do
        params_client = {
          "address"=>"123 Main st, Brooklyn NY 11215",
          "name"=>"asdfads",
          "password_confirmation"=>"123456",
          "phone"=>"123-123-1232",
          "description"=>"Just a test worker from Brooklyn",
          "link"=>"http://testlink.com",
          "password"=>"123456", "enabled" => true,
          "login"=>"test_worker", "type" => "Client",
          "email"=>"test_worker@tenhq.com"}
        params_client_ = {"role" => "1", "group" => "1"}

        companies = mock("List of companies")
        ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies
        
        client = mock_model(Client)
        Client.should_receive(:new).with(params_client).and_return client

        client_group = mock_model(ClientGroup, :id => params_client_["group"].to_i)
        ClientGroup.stub(:find).with(params_client_["group"]).and_return client_group
        client.stub(:client_groups=).with([client_group])
        role = mock_model(Role, :name => Role::CLIENT)
        client.should_receive(:roles=).and_return([role])
        client.should_receive(:save).and_return true

        post :create, :client => params_client, :client_ => params_client_
        flash[:info].should == "A client has been created successfully."
        response.should redirect_to :action => "new"
      end
    end
    describe "with invalid params" do
      it "empty name and password" do
        params_client = {
          "address"=>"123 Main st, Brooklyn NY 11215",
          "name"=>"",
          "password_confirmation"=>"",
          "phone"=>"123-123-1232",
          "description"=>"Just a test worker from Brooklyn",
          "link"=>"http://testlink.com",
          "password"=>"123456", "enabled" => true,
          "login"=>"test_worker", "type" => "Client",
          "email"=>"test_worker@tenhq.com"}
        params_client_ = {"group" => "1"}

        companies = mock("List of companies")
        ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies
        client = mock_model(Client)
        Client.should_receive(:new).with(params_client).and_return client

        client_group = mock_model(ClientGroup, :id => params_client_["group"].to_i)
        ClientGroup.stub(:find).with(params_client_["group"]).and_return client_group
        client.stub(:client_groups=).with([client_group])
        role = mock_model(Role, :name => Role::CLIENT)
        client.should_receive(:roles=).and_return([role])
        client.should_receive(:save).and_return false

        post :create, :client => params_client, :client_ => params_client_
        flash[:notice].should be_nil
        response.should_not redirect_to :action => "new"
      end
      it "empty no group, no role chose" do
        params_client = {
          "address"=>"123 Main st, Brooklyn NY 11215",
          "name"=>"fsdfs",
          "password_confirmation"=>"sdfasd",
          "phone"=>"123-123-1232",
          "description"=>"Just a test worker from Brooklyn",
          "link"=>"http://testlink.com",
          "password"=>"123456", "enabled" => true,
          "login"=>"test_worker", "type" => "Client",
          "email"=>"test_worker@tenhq.com"}
        params_client_ = {}

        companies = mock("List of companies")
        ClientCompany.should_receive(:all).with(:include => :client_groups).and_return companies

        client = mock_model(Client)
        Client.should_receive(:new).with(params_client).and_return client
        role = mock_model(Role, :name => Role::CLIENT)
        client.should_receive(:roles=).and_return([role])
        client.should_receive(:save).and_return false

        post :create, :client => params_client, :client_ => params_client_
        flash[:notice].should be_nil
        response.should_not redirect_to :action => "new"
      end
    end
  end

  describe "#destroy" do
    it "successful" do
      params_id = "1"
      client = mock_model(Client, :id => params_id, :enabled => true)
      Client.should_receive(:find_by_id).with(params_id).and_return client
      client.should_receive(:destroy)
      delete :destroy, :id => params_id
      response.should redirect_to admin_clients_path
    end

    it "unsuccessful" do
      id = "1"
      Client.should_receive(:find_by_id).with(id).and_return nil
      delete :destroy, :id => id
      flash[:notice].should == "No clients that fit ID: \"#{id}\" to remove."
      response.should redirect_to admin_clients_path
    end

  end

  describe "#confirm" do
    it " successful" do
      params_id = "1"
      client = mock_model(Client, :id => params_id)
      Client.should_receive(:find_by_id).with(params_id).and_return client
      get :confirm, :id => params_id
      assigns[:title_view].should == "Administration - Confirmation"
      response.should render_template(:confirm)
    end

    it "unsuccessful" do
      id = "1"
      Client.should_receive(:find_by_id).with(id).and_return nil
      get :confirm, :id => id
      flash[:notice].should == "No clients that fit ID: \"#{id}\" to remove."
      response.should redirect_to admin_clients_path
    end

  end
end

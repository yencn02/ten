require "spec_helper"
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe Admin::CompaniesController do

  before(:each) do
    login_as_admin
  end
  context "#index" do
    it "should be successful" do
      get :index
      response.should be_success
      assigns[:title_view].should == "Administration - Company Management"
    end
    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end

    it "should return list of companies with pagination" do
      page = 1
      companies = mock("Something")
      Company.should_receive(:paginate).with(:page => page, :per_page => 10).and_return companies
      get :index
      assigns(:companies).should == companies
    end
  end
  context "#new" do
    it "should be successful" do
      get :new
      response.should be_success
      assigns[:title_view].should == "Administration - Company Management"
    end
    it "should render the index template" do
      get :new
      response.should render_template(:new)
    end

    it "prepare data for the new page" do
      company = mock("A Company")
      Company.should_receive(:new).and_return company
      get :new
      assigns(:company).should == company
    end
  end
  context "#edit" do
    it "prepare data for the edit page" do
      company_id = 1
      company = mock_model(Company, :id => company_id.to_i, :enabled => true)
      Company.should_receive(:find).with(company_id).and_return company
      get :edit, :id => company_id
      assigns(:company).should == company
      response.should be_success
      response.should render_template(:edit)
      assigns[:title_view].should == "Administration - Company Management"
    end
  end

  context "#update" do
    it "successfully" do
      params_company = {"name" => "hehe1", "description" => "hehe2"}
      id = "1"
      company = mock_model(Company, :id => id.to_i)
      Company.stub(:find).with(id).and_return company

      company.should_receive(:update_attributes).with(params_company)
      company.should_receive(:save).and_return true
      path = "/admin/companies/#{id}"
      company.stub(:admin_company_path).and_return path
      put :update, :id => id, :company => params_company
      flash[:info].should == 'Company was updated successfully.'
      response.should redirect_to(path)
    end
    it "unsuccessfully" do
      params_company = {"name" => "", "description" => "hehe2"}
      id = "1"

      company = mock_model(Company, :id => id.to_i, :enabled => true)
      Company.stub(:find).with(id).and_return company

      company.should_receive(:update_attributes).with(params_company)
      company.should_receive(:save).and_return false
      put :update, :id => id, :company => params_company
      response.should render_template(:edit)
    end
  end

  describe "#show" do
    it "prepare data for the show page" do
      id = "1"

      company = mock_model(Company, :id => id.to_i, :enabled => true)
      Company.stub(:find).with(id).and_return company
      
      get :show, :id => id

      assigns(:company).should == company

      response.should be_success
      response.should render_template(:show)
      
      assigns[:title_view].should == "Administration - Company Management"
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "assigns a newly created worker" do
        params_company = {
          "name"=>"hehe1",
          "description"=>"hehe2",
        }

        company = mock_model(Company)
        Company.should_receive(:new).with(params_company).and_return company

        company.should_receive(:save).and_return true

        post :create, :company => params_company
        flash[:info].should == "A company has been created successfully."
        response.should redirect_to :action => "new"
      end
    end
    describe "with invalid params" do
      it "name is empty" do
        params_company = {
          "name"=>"",
          "description"=>"hehe2",
        }

        company = mock_model(Company)
        Company.should_receive(:new).with(params_company).and_return company

        company.should_receive(:save).and_return false

        post :create, :company => params_company
        response.should_not redirect_to :action => "new"
      end

      it "name is already taken" do
        company_name = "Endax"
        existed_company = mock_model(Company, :name => company_name)
        params_company = {
          "name"=> company_name,
          "description"=>"hehe2",
        }

        company = mock_model(Company)
        Company.should_receive(:new).with(params_company).and_return company

        company.should_receive(:save).and_return false

        post :create, :company => params_company
        response.should_not redirect_to :action => "new"
        
      end
    end
  end
  describe "#confirm_status" do
    it "successfully" do
      id = "1"
      params_new_status = "deactivate"

      company = mock_model(Company, :name => "Hello", :enabled => true)
      Company.stub(:find_by_id).with(id).and_return company
      get :confirm_status, :new_status => params_new_status, :id => id
      assigns[:title_view].should == "Administration - Deactivate Hello"
      response.should render_template(:confirm_status)
    end
    it "unsuccessfully" do
      id = "1"
      params_new_status = "deactivate"

      Company.stub(:find_by_id).with(id).and_return nil
      get :confirm_status, :new_status => params_new_status, :id => id
      flash[:notice].should == "No companies that fit ID: 1"
      response.should render_template(:confirm_status)
    end
  end
  
  describe "#set_status" do
    it "deactivate successfully" do
      id = "1"
      params_new_status = "deactivate"

      company = mock_model(Company, :enabled => true)
      Company.stub(:find_by_id).with(id).and_return company

      mapping = {"deactivate" => false, "activate" => true}

      company.should_receive(:enabled=).with(mapping[params_new_status])
      company.should_receive(:save)

      worker_groups = [mock_model(WorkerGroup)]
      company.should_receive(:worker_groups).and_return worker_groups

      worker_groups.each{|group|
        accounts = [mock_model(Client)]
        group.should_receive(:accounts).and_return accounts
        accounts.each{|client|
          client.should_receive(:enabled=).with(mapping[params_new_status])
          client.should_receive(:save)
        }
      }
      get :set_status, :new_status => params_new_status, :id => id
      flash[:info] = "A company has been deactivated successfully."
      response.should redirect_to :action => "show", :id => id
    end

    it "activate successfully" do
      id = "1"
      params_new_status = "activate"

      company = mock_model(Company, :enabled => false)
      Company.should_receive(:find_by_id).with(id).and_return company

      mapping = {"deactivate" => false, "activate" => true}

      company.should_receive(:enabled=).with(mapping[params_new_status])
      company.should_receive(:save)

      worker_groups = [mock_model(WorkerGroup)]
      company.should_receive(:worker_groups).and_return worker_groups

      worker_groups.each{|group|
        accounts = [mock_model(Client)]
        group.should_receive(:accounts).and_return accounts
        accounts.each{|client|
          client.should_receive(:enabled=).with(mapping[params_new_status])
          client.should_receive(:save)
        }
      }
      get :set_status, :id => id, :new_status => params_new_status
      flash[:info].should == "A company has been activated successfully."
      response.should redirect_to :action => "show", :id => id
    end

    it "unsuccessfully" do
      id = "1"
      params_new_status = "deactivate"

      Company.stub(:find_by_id).with(id).and_return nil

      get :set_status, :new_status => params_new_status, :id => id
      flash[:info].should be_nil
      response.should render_template(:confirm_status)
    end
  end

  describe "#destroy" do
    it "successful" do
      params_id = "1"
      company = mock_model(Company, :id => params_id, :enabled => true)
      Company.should_receive(:find_by_id).with(params_id).and_return company
      company.should_receive(:destroy)
      delete :destroy, :id => params_id
      response.should redirect_to admin_companies_path
    end

    it "unsuccessful" do
      id = "1"
      Company.should_receive(:find_by_id).with(id).and_return nil
      delete :destroy, :id => id
      flash[:notice].should == "No companies that fit ID: \"#{id}\" to remove."
      response.should redirect_to admin_companies_path
    end

  end

  describe "#confirm" do
    it " successful" do
      params_id = "1"
      company = mock_model(Company, :id => params_id, :enabled => true)
      Company.should_receive(:find_by_id).with(params_id).and_return company
      get :confirm_remove, :id => params_id
      assigns[:title_view].should == "Administration - Confirmation"
      response.should render_template(:confirm_remove)
    end

    it "unsuccessful" do
      id = "1"
      Company.should_receive(:find_by_id).with(id).and_return nil
      get :confirm_remove, :id => id
      flash[:notice].should == "No companies that fit ID: \"#{id}\" to remove."
      response.should redirect_to admin_companies_path
    end

  end
end


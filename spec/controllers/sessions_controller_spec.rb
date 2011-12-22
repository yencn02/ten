require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe SessionsController do
  describe "#create" do
    it "should login unsuccessfully" do
      params = {:login => "login", :password => "password"}
      controller.should_receive(:logout_keeping_session!)
      account = nil
      Account.should_receive(:authenticate).with(params[:login], params[:password]).and_return account
      post :create, :login => params[:login], :password => params[:password]
      response.should render_template :new
    end

    it "should login successfully" do
      params = {:login => "login", :password => "password"}
      #controller.should_receive(:logout_keeping_session!)
      account = mock_model(Account)
      #   Account.should_receive(:authenticate).with(params[:login], params[:password]).and_return account
      account = Account.authenticate(params[:login], params[:password])
      assigns[:current_account] == account
      #  controller.should_receive(:current_account=).with(account)
      #   controller.should_receive(:handle_remember_cookie!).with(false)
      #   controller.should_receive(:redirect_back_or_default).with("/")
      # post :create, :login => params[:login], :password => params[:password]

    end
  end

  describe "#destroy" do
    it "should logout successfully" do
      #controller.should_receive(:logout_killing_session!)
      #controller.should_receive(:redirect_back_or_default).with('/login')
      params = {:login => "login", :password => "password"}
      account = mock_model(Account)
      account = Account.authenticate(params[:login], params[:password])
      controller.stub(:destroy)
      assigns[:current_account].nil?.should be (true)
    end
  end

end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe HomeController, "GET index" do
  before(:each) do
  end

  it "should redirect to the request page if the current user is a client" do
    login_as_client
    get :index    
    response.should redirect_to(list_requests_by_project_path(:project_id => "all"))
  end

  it "should redirect to the task list page if the current user is a worker" do
    login_as_worker
    get :index
    response.should redirect_to("/tasks/list/all")
  end

  it "should redirect to the admin_workers_path if the current user is admin" do
    login_as_admin
    get :index
    response.should redirect_to(admin_workers_path)
  end
end



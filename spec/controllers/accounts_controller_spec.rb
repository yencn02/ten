require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"

describe AccountsController do
  before(:each) do
    @current_account = login_as_worker
  end
  describe "paginate_workers" do
    it "should render :partial" do
      params_selected_worker = "1"
      workers = mock("List of workers")

      Worker.should_receive(:paginate_by_activity).with(@current_account, @current_page).and_return workers
      get :paginate_workers, :selected_worker => params_selected_worker

      response.should render_template "accounts/_navbar_worker"
    end
  end
end

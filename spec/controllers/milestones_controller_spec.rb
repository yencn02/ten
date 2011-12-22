require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe MilestonesController do
  before :each do
    @current_account = login_as_manager
    #For menu
    Project.paginate_by_activity(@current_account, "active", nil)
  end

  describe "#list" do
    it "load all milestones" do
      Milestone.should_receive(:milestone_by_due_date).with(nil)
      get :list, :project_id => "all"
    end

    it "load all milestones on selected project" do
      Milestone.should_receive(:milestone_by_due_date).with(1)
      get :list, :project_id => "1", :page => "1"
    end
  end

  describe "#new" do
    it "load all milestones" do
      get :new, :project_id => "1"
    end
  end

end

require "spec_helper"

describe WorkerGroup do
  describe "#association" do
    it "#with :worker_group_accounts" do
      association = WorkerGroup.reflect_on_association(:worker_group_accounts)
      association.macro.should == :has_many
      association.class_name.should == 'WorkerGroupAccount'
    end

    it "#with :accounts" do
      association = WorkerGroup.reflect_on_association(:accounts)
      association.macro.should == :has_many
      association.class_name.should == 'Account'
    end

    it "#with :projects" do
      association = WorkerGroup.reflect_on_association(:projects)
      association.macro.should == :has_many
      association.class_name.should == 'Project'
    end

    it "#with :company" do
      association = WorkerGroup.reflect_on_association(:company)
      association.macro.should == :belongs_to
      association.class_name.should == 'Company'
    end
  end

  it "#admin_worker_group_path" do
    group = Factory.create(:worker_group, :name => "Worker Group")
    path = "/admin/worker_groups/#{group.id}"
    group.admin_worker_group_path.should == path
  end

end
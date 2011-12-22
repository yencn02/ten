require "spec_helper"

describe Company do
  describe "#association" do
    it "#with :worker_groups" do
      association = Company.reflect_on_association(:worker_groups)
      association.macro.should == :has_many
      association.class_name.should == 'WorkerGroup'
    end
  end

  it "#admin_company_path" do
    company = Factory.create(:company, :name => "company")
    path = "/admin/companies/#{company.id}"
    company.admin_company_path.should == path
  end

end
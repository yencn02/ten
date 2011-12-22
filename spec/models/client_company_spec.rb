require "spec_helper"

describe ClientCompany do
  describe "#association" do
    it "#with :client_groups" do
      association = ClientCompany.reflect_on_association(:client_groups)
      association.macro.should == :has_many
      association.class_name.should == 'ClientGroup'
    end
  end
  
  it "#admin_client_company_path" do
    company = Factory.create(:client_company, :name => "Client company")
    path = "/admin/client_companies/#{company.id}"
    company.admin_client_company_path.should == path
  end

end
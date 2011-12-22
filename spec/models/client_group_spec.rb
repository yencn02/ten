require "spec_helper"

describe ClientGroup do
  describe "#association" do
    it "#with :client_group_accounts" do
      association = ClientGroup.reflect_on_association(:client_group_accounts)
      association.macro.should == :has_many
      association.class_name.should == 'ClientGroupAccount'
    end

    it "#with :accounts" do
      association = ClientGroup.reflect_on_association(:accounts)
      association.macro.should == :has_many
      association.class_name.should == 'Account'
    end

    it "#with :projects" do
      association = ClientGroup.reflect_on_association(:projects)
      association.macro.should == :has_many
      association.class_name.should == 'Project'
    end

    it "#with :client_company" do
      association = ClientGroup.reflect_on_association(:client_company)
      association.macro.should == :belongs_to
      association.class_name.should == 'ClientCompany'
    end
  end

  describe "Instance Methods" do
    before :each do
      @group = ClientGroup.new
    end
    it "#admin_client_group_path" do
      path = "/admin/client_groups/#{@group.id}"
      @group.admin_client_group_path.should == path
    end
  
    it "#extend_name" do
      @group.stub(:client_company).and_return mock_model(ClientCompany, :name => "client company name")
      @group.extend_name.should == "#{@group.client_company.name} - #{@group.name}"
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Worker do
  before(:each) do
    @valid_attributes = {
      :name => "role"
    }
  end
  describe "#association" do
    it "#has_and_belongs_to_many :acounts" do
      association = Role.reflect_on_association(:accounts)      
      association.macro.should == :has_and_belongs_to_many
      association.class_name.should == 'Account'
    end
  end

  it "should create a new instance successfully" do
    role = Role.new(@valid_attributes)
    role.valid?.should be_true
  end

  it "#worker_roles" do
    roles = mock("Something")
    Role.should_receive(:all).with(:conditions => ["name not in(?)", [Role::ADMIN, Role::CLIENT]]).and_return roles
    Role.worker_roles.should == roles
  end
end
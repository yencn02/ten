require 'spec_helper'

describe AccountsRole do
  describe "#association" do
    it "#belongs_to :workers" do
      association = AccountsRole.reflect_on_association(:account)
      association.macro.should == :belongs_to
      association.class_name.should == 'Account'
    end
    it "#belongs_to :roles" do
      association = AccountsRole.reflect_on_association(:role)
      association.macro.should == :belongs_to
      association.class_name.should == 'Role'
    end
  end
end
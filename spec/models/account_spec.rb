require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  describe "#authenticate" do
    it "return nil if login is blank" do
      login = ""
      password = "123456"

      Account.authenticate(login, password).should be_nil
    end

    it "should return Account object" do
      login = "test123"
      password = "123456"
      user = mock_model(Account)
      Account.should_receive(:find_by_login).with(login, :conditions => {:enabled => true}).and_return user
      user.should_receive(:authenticated?).with(password).and_return true
      Account.authenticate(login, password).should == user
    end

    it "should return nil when no account match" do
      login = "test123"
      password = "123456"
      user = nil
      Account.should_receive(:find_by_login).with(login, :conditions => {:enabled => true}).and_return nil
      Account.authenticate(login, password).should == nil
    end

  end  
end
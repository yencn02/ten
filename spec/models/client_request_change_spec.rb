require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClientRequestChange do
  describe "Class Methods" do
    it "#paginate_by_client_request" do
      page = mock("page")
      per_page = mock("per_page")
      client_request_id = mock("client_request_id")
      result = mock("result")
      ClientRequestChange.should_receive(:paginate).with(:page => page, :per_page => per_page,
        :conditions => ["client_request_id = ?", client_request_id], :order => 'created_at DESC').and_return result
      ClientRequestChange.paginate_by_client_request(client_request_id, page, per_page).should == result
    end

    describe "#find_by_id_with_security_check" do
      it "should raise ArgumentError exception" do
        id = mock("id")
        lambda{
          ClientRequestChange.find_by_id_with_security_check(id, nil)
        }.should raise_error(ArgumentError)
      end

      it "should return nil" do
        id = mock("id")
        account = mock("account")
        ClientRequestChange.should_receive(:find_by_id).with(id).and_return nil
        ClientRequestChange.find_by_id_with_security_check(id, account).should be_nil
      end

      it "should return change" do
        id = mock("id")
        account = mock("account")
        change = mock("change")
        ClientRequestChange.should_receive(:find_by_id).with(id).and_return change
        change.should_receive(:allows_view?).with(account).and_return true
        ClientRequestChange.find_by_id_with_security_check(id, account).should == change
      end

      it "should raise SecurityError exception" do
        id = mock("id")
        account = mock("account", :id => 1)
        change = mock("change")
        ClientRequestChange.should_receive(:find_by_id).with(id).and_return change
        change.should_receive(:allows_view?).with(account).and_return false
        lambda{
          ClientRequestChange.find_by_id_with_security_check(id, account)
        }.should raise_error(SecurityError)
      end
    end
  end#Class Methods

  describe "Instance Methods" do
    before :each do
      @change = ClientRequestChange.new
    end

    it "#allows_view?" do
      account = mock("account")
      @change.allows_view?(account).should == true
    end
  end#Instance Methods
end
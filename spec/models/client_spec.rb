require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Client do
  describe "Instance Methods" do
    before :each do
      @client = Client.new
    end

    it "#admin_client_path" do
      path = "/admin/clients/#{@client.id}"
      @client.admin_client_path.should == path
    end

    it "#project_ids" do
      project_ids = []
      client_groups = []
      (rand(10) + 1).times do |i|
        projects = []
        (rand(5) + 1).times do |j|
          project_ids << i * j
          projects << mock_model(Project, :id => i * j)
        end
        client_groups << mock_model(ClientGroup, :projects => projects)
      end
      @client.stub(:client_groups).and_return client_groups
      @client.project_ids.should == project_ids
    end
  end
end
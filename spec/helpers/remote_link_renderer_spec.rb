require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RemoteLinkRenderer do
  include WillPaginate::ViewHelpers
  it "RemoteLinkRenderer" do
    @projects = [mock_model(Project),mock_model(Project)].paginate(:page => 1, :per_page => 1)
    options = {
      :remote => mock("remote"),
      :renderer => "MenuLinkRenderer",
      :page_links => true,
      :params => {:controller => :projects, :action => :paginate, :type => "project"}
    }
    template = mock("template")
    remote = RemoteLinkRenderer.new
    options.should_receive(:delete).with(:remote)
    remote.prepare(@projects, options, template)
    2.times.each do
      template.should_receive(:url_for).and_return "url"
    end
    2.times.each do
      template.should_receive(:content_tag)
      template.should_receive(:link_to_remote)
    end
    request = mock("request", :get? => false)
    template.should_receive(:request).and_return request
    
    remote.to_html
  end
end
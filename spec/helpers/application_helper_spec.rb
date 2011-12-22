require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ApplicationHeler" do
  include ApplicationHelper

  it "should show a custom menu for clients" do
    should_receive(:current_account).and_return(Client.new)
    should_receive(:render).with(:partial => "layouts/client_menu")
    should_not_receive(:render).with(:partial => "layouts/worker_menu")
    menu
  end

  it "should show a custom menu for workers" do
    should_receive(:current_account).and_return(Worker.new)
    should_receive(:render).with(:partial => "layouts/worker_menu", :locals => {
      :top_menu_items => nil,
      :middle_menu_items => nil,
      :bottom_menu_items => nil })
    should_not_receive(:render).with(:partial => "layouts/client_menu")
    menu
  end

  it "#set_focus_to" do
    set_focus_to(:object, :method).should == javascript_tag("$('object_method').focus()");
  end

end

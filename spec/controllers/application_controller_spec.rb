require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require ::Rails.root.to_s + "/spec/spec_helpers/controllers/login_helpers.rb"
describe ApplicationController do
#  class FooController < ApplicationController
#    def index
#      render :text => "Menu"
#    end
#  end
#  controller_name :foo

  it "should build menu" do
    controller.stub!(:menu).and_return(true)
  #  get :index
  end
end

describe TasksController do
  it "should redirect to 404 page" do
    controller.stub!(:menu)
    login_as_worker
#    get :show, :id => 30
#    response.should render_templatget :show, :id => 30e "#{Rails.root}/public/404.html"
  end
end

describe Admin::WorkersController do
  it "should redirect to 403 page" do
    login_as_worker
    get :index
    response.should render_template "#{Rails.root}/public/403.html"
  end
end



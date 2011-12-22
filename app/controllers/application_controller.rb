class ApplicationController < ActionController::Base
 
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing
  # acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem

  # You can move this into a different controller, if you wish.  This module gives you the
  # require_role helpers, and others.
  include RoleRequirementSystem

  # Build the main navigation
  include Menu
  before_filter :menu

  # Exception handling configuration
  #rescue_from Exception, :with => :rescue_all_exceptions

  def rescue_all_exceptions(exception)
    
    case exception
#      when SecurityError then
#        render :file => "#{Rails.root}/public/403.html", :status => 403
      when ActiveRecord::RecordNotFound then
         render :file => "#{Rails.root}/public/404.html", :status => 404

      else
         render :file => "#{Rails.root}/public/500.html", :status => 500
    end
    logger.error "[ERROR] #{exception}"
  end

  def application_helper
    Helper.instance
  end

  def current_page(page_param = params[:page])
    page_param.to_i == 0 ? 1 : page_param.to_i
  end

  def all_list_tasks_path
      "/tasks/list/all"
  end

  class Helper
    include Singleton
    include ApplicationHelper
  end
end

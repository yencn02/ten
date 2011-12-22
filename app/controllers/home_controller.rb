class HomeController < ApplicationController
  # Authentication & authorization configuration
  before_filter :login_required, :except => [ :template ]

  # Redirect to the home page based on the account type
  def index
    case current_account.read_attribute(:type)
    # Set the request index page as clients' home page
    when Client.to_s
      redirect_to list_requests_by_project_path(:project_id => "all")
    # Set the task list page as workers' home page
    when Worker.to_s
      if current_account.has_role?(Role::ADMIN)
        redirect_to admin_workers_path
      else
        redirect_to all_list_tasks_path
      end
    end
  end
end

class MilestonesController < ApplicationController
  layout "application"
  before_filter :login_required
  
  def list
    selected_project = params[:project_id] || "all"
    if selected_project == "all"
      session[:active_project] = nil
    else
      session[:active_project] = params[:project_id].to_i
    end
    @milestones = Milestone.milestone_by_due_date(session[:active_project])
  end

  def new

  end
end

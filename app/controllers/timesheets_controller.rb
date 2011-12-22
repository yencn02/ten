class TimesheetsController < ApplicationController
  layout "application"
  before_filter :login_required
  require_role [Role::ADMIN, Role::LEAD, Role::MANAGER], :except => [:create, :workers, :list_by_worker]
  
  PER_PAGE = 10
  def index
    redirect_to :action => :projects
  end

  def projects
    page = params[:page] || 1
    @projects = Project.paginate_by_activity(current_account , "active", page, PER_PAGE)
  end

  def workers
    page = params[:page] || 1
    @workers = Worker.paginate_by_activity(current_account, page, PER_PAGE)
  end
  
  def list_by_project
    page = (params[:page] || 1).to_i
    selected_project = params[:project_id] || "all"
    if selected_project == "all"
      session[:active_project] = nil
      @tasks = Task.paginate(:page => page, :per_page => PER_PAGE)
    else
      @project = Project.find(params[:project_id])
      @tasks = Task.paginate(:conditions => ["project_id =?", params[:project_id]], :page => page, :per_page => PER_PAGE)
      session[:active_project] = @project.id
    end
  end

  def list_by_worker
    page = (params[:page] || 1).to_i
    selected_worker = params[:worker_id] || "all"
    if selected_worker == "all"
      @tasks = Task.paginate(:page => page, :per_page => PER_PAGE, :order => "created_at DESC")
    else      
      @worker = Worker.find(params[:worker_id])
      @tasks = Task.paginate(:conditions => ["worker_id =?", params[:worker_id]], :page => page, :per_page => PER_PAGE, :order => "created_at DESC")
    end
  end

  def create    
    @billable_time = BillableTime.new()
    @billable_time.description = params[:description]
    @billable_time.billed_hour = params[:billed_hour]
    @billable_time.completed = params[:completed]
    @billable_time.task_id = params[:task_id]    
    render :update do |page|
      if @billable_time.save_with_security_check(current_account) && @billable_time.errors.empty?
        unless params[:completed].nil?          
          task = @billable_time.task
          task.complete          
          task.save
          client_request = @billable_time.task.client_request
          client_request.review
          client_request.save          
        end
        flash[:info] = "Timesheet create successful!"
        page.reload
      else
        page.call "TimesheetEntryForm.onFocus", params[:task_id]
        page.replace_html "app-message", (error_messages_for :billable_time)
      end
    end
  end

end

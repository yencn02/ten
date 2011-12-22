class ProjectsController< ApplicationController
  layout "application"
  before_filter :login_required
  require_role Role::MANAGER, :except => [:paginate]

  def index
    redirect_to :action => "active"
  end

  def active
    page = params[:page] || 1 
    @projects = Project.paginate(:page => page, :per_page => 10, :conditions => {:status => Project::ACTIVE})
    render :action => "index"
  end

  def inactive
    page = params[:page] || 1
    @projects = Project.paginate(:page => page, :per_page => 10, :conditions => {:status => Project::INACTIVE})
    render :action => "index"
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      Milestone.create({:title => "Default milestone", :project => @project, :due_date => @project.created_at})
      flash[:info] = "Project is saved successfully"
      render :update do |page|
        page.redirect_to :action => @project.status
      end
    else
      render :update do |page|
        page.show "#facebox #errorExplanation"
        page.replace_html "#facebox #errorExplanation", error_messages_for("project")
      end
    end
  end
  
  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
    @client_groups = ClientGroup.all
    @worker_groups = WorkerGroup.all
    render :layout => false
  end

  def edit 
    @project = Project.find(params[:id])
    @client_groups = ClientGroup.all
    @worker_groups = WorkerGroup.all
    render :layout => false
  end

  def update 
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:info] = "Project is saved successfully"
      render :update do |page|
        page.reload
      end
    else
      render :update do |page|
        page.show "#facebox #errorExplanation"
        page.replace_html "#facebox #errorExplanation", error_messages_for("project")
      end
    end
  end

  def destroy
    project = Project.find(params[:id])
    if project
      status = project.status
      project.destroy
      session[:active_project] = nil
      flash[:info] = "A project has been removed successfully."
      redirect_to "/projects/#{status}"
    else
      flash[:notice] = "No project that fit ID: \"#{params[:id]}\" to delete."
      redirect_to url_for(:action => "index", :status => status)
    end
    
  end
  
  def paginate
    @current_page = params[:page]    
    @projects = Project.paginate_by_activity(current_account , "active", @current_page)
    case params[:type]
    when "milestone"
      render :partial => "projects/navbar_milestone",
        :locals => {:projects => @projects, :page => @current_page}
    when "request"
      render :partial => "projects/navbar_request",
        :locals => {:projects => @projects, :page => @current_page}
    when "client_request"
      render :partial => "projects/navbar_client_request",
        :locals => {:projects => @projects, :page => @current_page}
    when "task"
      render :partial => "projects/navbar_task",
        :locals => {:projects => @projects, :page => @current_page}
    when "timesheet"
      render :partial => "projects/navbar_timesheet",
        :locals => {:projects => @projects, :page => @current_page}
    end
  end
end

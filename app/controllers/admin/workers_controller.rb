class Admin::WorkersController < ApplicationController
  layout "application"
  before_filter :login_required
  before_filter :title_view
  require_role Role::ADMIN
  def index
    page = params[:page] || 1
    @workers = Worker.paginate(:page => page, :per_page => 10)
  end

  def new
    @worker = Worker.new
    @companies = Company.all(:include => :worker_groups)
    @roles = Role.worker_roles
  end

  def edit
    @worker = Worker.find(params[:id])
    params[:worker_] = {
      :role => @worker.roles[0].nil? ? 0 : @worker.roles[0].id
    }
    @worker_groups = WorkerGroup.all
    @companies = Company.all(:include => :worker_groups)
    @roles = Role.worker_roles
    @dynamic_bottom_menu_items = worker_dynamic_mnu_items(params[:id], session[:account_id])
  end

  def update
    @worker_groups = WorkerGroup.all
    @companies = Company.all(:include => :worker_groups)
    @worker = Worker.find(params[:id])
    @roles = Role.worker_roles
    if params[:worker_] && !params[:worker_][:role].blank?
      role = Role.find(params[:worker_][:role])
      @worker.roles = [role]
    end
    @worker.update_attributes(params[:worker])
    if @worker.save
      flash[:info] = 'Worker was updated successfully.'
      redirect_to(@worker.admin_worker_path)
    else
      @dynamic_bottom_menu_items = worker_dynamic_mnu_items(params[:id], session[:account_id])
      render :action => "edit"
    end
  end

  def show
    @worker = Worker.find(params[:id])
    @dynamic_bottom_menu_items = worker_dynamic_mnu_items(params[:id], session[:account_id])
  end
  
  def create
    @roles = Role.worker_roles
    @companies = Company.all(:include => :worker_groups)
    params[:worker][:type] = "Worker"
    params[:worker][:enabled] = true
    @worker = Worker.new(params[:worker])
    if !params[:worker_][:role].blank?
      role = Role.find(params[:worker_][:role])
      @worker.roles = [role]
    end
    if !params[:worker_][:group].blank?
      worker_group = WorkerGroup.find(params[:worker_][:group])
      @worker.worker_groups = [worker_group]
    end
    if @worker.save
      flash[:info] = "A worker has been created successfully."
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end

  def destroy
    worker = Worker.find_by_id(params[:id])
    if worker
      worker.destroy
      flash[:info] = "A worker has been removed successfully."
    else
      flash[:notice] = "No workers that fit ID: \"#{params[:id]}\" to remove."
    end
    redirect_to admin_workers_path
  end

  def confirm
    @worker = Worker.find_by_id(params[:id])
    if @worker
      @title_view = "Administration - Confirmation"
      @dynamic_bottom_menu_items = worker_dynamic_mnu_items(params[:id], session[:account_id])
    else
      flash[:notice] = "No workers that fit ID: \"#{params[:id]}\" to remove."
      redirect_to admin_workers_path
    end
  end
  private
  def title_view
    @title_view = "Administration - Worker Management"
  end
end
class Admin::WorkerGroupsController < ApplicationController
  layout "application"
  before_filter :login_required
  before_filter :title_view, :except => [:create]
  require_role Role::ADMIN
  def index
    page = params[:page] || 1
    @worker_groups = WorkerGroup.paginate(:page => page, :per_page => 10, :include => :company, :order => "created_at DESC")
  end

  def new
    @companies = Company.all
    @worker_group = WorkerGroup.new
  end

  def edit
    @companies = Company.all
    @worker_group = WorkerGroup.find(params[:id])
    @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
  end

  def update
    @worker_group = WorkerGroup.find(params[:id])
    if params[:worker_group]
      @worker_group.update_attributes(params[:worker_group])
    elsif params[:accounts] && params[:accounts].size > 0
      if (params[:action_type] == "add")
        workers = Worker.find(params[:accounts])
        workers.each{|worker| @worker_group.accounts << worker if !@worker_group.accounts.include?(worker) }
      else
        accounts = []
        @worker_group.accounts.each{|worker| accounts << worker if !params[:accounts].include?(worker.id.to_s) }
        @worker_group.accounts = accounts
      end
    end
    if @worker_group.save
      flash[:info] = 'A worker group has been updated successfully.'
      redirect_to(@worker_group.admin_worker_group_path)
    else
      @companies = Company.all
      @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
      render :action => "edit"
    end
  end

  def show
    @worker_group = WorkerGroup.find(params[:id], :include => :accounts)
    @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
  end

  def create
    @worker_group = WorkerGroup.new(params[:worker_group])
    if @worker_group.save
      flash[:info] = "A worker group has been created successfully."
      redirect_to :action => "new"
    else
      @companies = Company.all
      render :action => "new"
    end
  end
  def confirm
    @worker_group = WorkerGroup.find_by_id(params[:id])
    if @worker_group
      @title_view = "Administration - #{params[:new_status].to_s.titlecase} #{@worker_group.name}"
    else
      flash[:notice] = "No worker groups that fit ID: \"#{params[:id]}\""
    end
    @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
  end

  def destroy
    @worker_group = WorkerGroup.find_by_id(params[:id])
    if @worker_group
      @worker_group.destroy
      redirect_to admin_worker_groups_path
    else
      flash[:notice] = "No worker groups that fit ID: \"#{params[:id]}\""
      render :action => "confirm"
      @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
    end
  end

  def add_worker
    @worker_group = WorkerGroup.find_by_id(params[:id])
    if @worker_group
      non_candidate_workers = @worker_group.accounts
      non_candidate_worker_ids = non_candidate_workers.map{|x| x.id}
      if non_candidate_worker_ids.size > 0
        @candidate_workers = Worker.where("id not in(?)", non_candidate_worker_ids)
      else
        @candidate_workers = Worker.all
      end
    else
      flash[:notice] = "No worker groups that fit ID: \"#{params[:id]}\""
    end
    @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
  end

  def remove_worker
    @worker_group = WorkerGroup.find_by_id(params[:id])
    if @worker_group
      @workers = @worker_group.accounts
    else
      flash[:notice] = "No worker groups that fit ID: \"#{params[:id]}\""
    end
    @dynamic_bottom_menu_items = worker_group_dynamic_mnu_items(params[:id])
  end
  
  private
  def title_view
    @title_view = "Administration - Worker group Management"
  end

end
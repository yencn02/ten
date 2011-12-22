class Admin::CompaniesController < ApplicationController
  layout "application"
  before_filter :login_required
  before_filter :title_view, :except => [:create]
  require_role Role::ADMIN
  def index
    page = params[:page] || 1
    @companies = Company.paginate(:page => page, :per_page => 10)
  end

  def new
    @company = Company.new
  end

  def edit
    @company = Company.find(params[:id])    
    @dynamic_bottom_menu_items = company_dynamic_mnu_items(@company.id, @company.enabled)     
  end

  def update
    @company = Company.find(params[:id])
    @company.update_attributes(params[:company])
    if @company.save
      flash[:info] = 'Company was updated successfully.'
      redirect_to(@company.admin_company_path)
    else
      @dynamic_bottom_menu_items = company_dynamic_mnu_items(@company.id, @company.enabled)
      render :action => "edit"
    end
  end

  def show
    @company = Company.find(params[:id])
    @dynamic_bottom_menu_items = company_dynamic_mnu_items(@company.id, @company.enabled)
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:info] = "A company has been created successfully."
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end
  def confirm_status
    @company = Company.find_by_id(params[:id])
    if @company
      @title_view = "Administration - #{params[:new_status].to_s.titlecase} #{@company.name}"
      @dynamic_bottom_menu_items = company_dynamic_mnu_items(@company.id, @company.enabled)
    else
      flash[:notice] = "No companies that fit ID: #{params[:id]}"
    end
  end
  def set_status
    company = Company.find_by_id(params[:id])
    if company
      status = !company.enabled
      company.enabled = status
      company.save
      company.worker_groups.each{|group|
        group.accounts.each{|client|
          client.enabled = status
          client.save
        }
      }
      mapping = { true => "activated", false => "deactivated"}
      flash[:info] = "A company has been #{mapping[status]} successfully."
      redirect_to :action => "show", :id => params[:id]
    else
      render :action => "confirm_status"
      flash[:notice] = "No companies that fit ID: #{params[:id]}"
    end
  end
  
  def destroy
    company = Company.find_by_id(params[:id])
    if company
      company.destroy
      flash[:info] = "A company has been removed successfully."
    else
      flash[:notice] = "No companies that fit ID: \"#{params[:id]}\" to remove."
    end
    redirect_to admin_companies_path
  end

  def confirm_remove
    @company = Company.find_by_id(params[:id])
    if @company
      @title_view = "Administration - Confirmation"
      @dynamic_bottom_menu_items = company_dynamic_mnu_items(@company.id, @company.enabled)
    else
      flash[:notice] = "No companies that fit ID: \"#{params[:id]}\" to remove."
      redirect_to admin_companies_path
    end
  end
  private
  def title_view
    @title_view = "Administration - Company Management"
  end
end
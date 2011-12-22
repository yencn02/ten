class Admin::ClientCompaniesController < ApplicationController
  layout "application"
  before_filter :login_required
  before_filter :title_view
  require_role Role::ADMIN
  def index
    page = params[:page] || 1
    @companies = ClientCompany.paginate(:page => page, :per_page => 10)
  end

  def new
    @company = ClientCompany.new
  end

  def edit
    @company = ClientCompany.find(params[:id])
    @dynamic_bottom_menu_items = client_company_dynamic_mnu_items(@company.id, @company.enabled)
  end

  def update
    @company = ClientCompany.find(params[:id])
    @company.update_attributes(params[:client_company])
    if @company.save
      flash[:info] = 'Client company has been updated successfully.'
      redirect_to(@company.admin_client_company_path)
    else
      @dynamic_bottom_menu_items = client_company_dynamic_mnu_items(@company.id, @company.enabled)
      render :action => "edit"
    end
  end

  def show
    @company = ClientCompany.find(params[:id])
    @dynamic_bottom_menu_items = client_company_dynamic_mnu_items(@company.id, @company.enabled)
  end

  def create
    @company = ClientCompany.new(params[:client_company])
    if @company.save
      ClientGroup.create(:name => "Default", :client_company_id => @company.id)
      flash[:info] = "A client company has been created successfully."
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end
  
  def confirm_status
    @company = ClientCompany.find_by_id(params[:id])
    if @company
      @title_view = "Administration - #{params[:new_status].to_s.titlecase} #{@company.name}"
      @dynamic_bottom_menu_items = client_company_dynamic_mnu_items(@company.id, @company.enabled)
    else
      render :action => "confirm_status"
      flash[:notice] = "No client companies that fit ID: #{params[:id]}"
    end
  end

  def set_status
    company = ClientCompany.find_by_id(params[:id])
    if company
      status = !company.enabled
      company.enabled = status
      company.save
      company.client_groups.each{|group|
        group.accounts.each{|client|
          client.enabled = status
          client.save
        }
      }
      mapping = { true => "activated", false => "deactivated"}
      flash[:info] = "A client company has been #{mapping[status]} successfully."
      redirect_to :action => "show", :id => params[:id]
    else
      render :action => "confirm_status"
      flash[:notice] = "No client companies that fit ID: #{params[:id]}"
    end
  end

  def destroy
    company = ClientCompany.find_by_id(params[:id])
    if company
      company.destroy
      flash[:info] = "A client company has been removed successfully."
    else
      flash[:notice] = "No client companies that fit ID: \"#{params[:id]}\" to remove."
    end
    redirect_to admin_client_companies_path
  end

  def confirm_remove
    @company = ClientCompany.find_by_id(params[:id])
    @title_view = "Administration - Confirmation"
    if @company
      @dynamic_bottom_menu_items = client_company_dynamic_mnu_items(@company.id, @company.enabled)
    else
      flash[:notice] = "No client companies that fit ID: \"#{params[:id]}\" to remove."
      redirect_to admin_client_companies_path
    end
  end
  
  private
  def title_view
    @title_view = "Administration - Client Company Management"
  end
end
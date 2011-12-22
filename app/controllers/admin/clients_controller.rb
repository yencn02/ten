class Admin::ClientsController < ApplicationController
  layout "application"
  before_filter :login_required
  before_filter :title_view, :except => [:create]
  require_role Role::ADMIN
  def index
    page = params[:page] || 1
    @clients = Client.paginate(:page => page, :per_page => 10)
  end

  def new
    @client = Client.new
    @companies = ClientCompany.all(:include => :client_groups)
    @groups = Array.new{["" => ""]}
  end

  def edit
    @client = Client.find(params[:id])
    @companies = ClientCompany.all(:include => :client_groups)
    @dynamic_bottom_menu_items = client_dynamic_mnu_items(params[:id])
  end

  def update
    @companies = ClientCompany.all(:include => :client_groups)
    @client = Client.find(params[:id])
    @client.update_attributes(params[:client])
    if @client.save
      flash[:info] = 'Client was updated successfully.'
      redirect_to(@client.admin_client_path)
    else
      render :action => "edit"
      @dynamic_bottom_menu_items = client_dynamic_mnu_items(params[:id])
    end
  end

  def show
    @client = Client.find(params[:id])
    @dynamic_bottom_menu_items = client_dynamic_mnu_items(params[:id])
  end

  def create
    @companies = ClientCompany.all(:include => :client_groups)
    @client_company = params[:client_][:company]

    @groups = ClientGroup.where(:client_company_id => @client_company)
    @client_group = params[:client_][:group]
    params[:client][:type] = "Client"
    params[:client][:enabled] = true
    @client = Client.new(params[:client])
    if !params[:client_][:group].blank?
      client_group = ClientGroup.find(params[:client_][:group])
      @client.client_groups = [client_group]
    end

    @client.roles = [Role.find_by_name(Role::CLIENT)]
    if @client.save
      flash[:info] = "A client has been created successfully."
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end
  
  def destroy
    client = Client.find_by_id(params[:id])
    if client
      client.destroy
      flash[:info] = "A client has been removed successfully."
    else
      flash[:notice] = "No clients that fit ID: \"#{params[:id]}\" to remove."
    end
    redirect_to admin_clients_path
  end

  def confirm
    @client = Client.find_by_id(params[:id])
    if @client
      @title_view = "Administration - Confirmation"
      @dynamic_bottom_menu_items = client_dynamic_mnu_items(params[:id])
    else
      flash[:notice] = "No clients that fit ID: \"#{params[:id]}\" to remove."
      redirect_to admin_clients_path
    end
  end

  private
  def title_view
    @title_view = "Administration - Client Management"
  end
end
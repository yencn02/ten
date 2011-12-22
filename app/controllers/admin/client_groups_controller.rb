class Admin::ClientGroupsController < ApplicationController
  layout "application"
  before_filter :login_required
  before_filter :title_view, :except => [:create]
  require_role Role::ADMIN
  def index
    page = params[:page] || 1
    @client_groups = ClientGroup.paginate(:page => page, :per_page => 10, :include => :client_company, :order => "created_at DESC")
  end

  def new
    @companies = ClientCompany.all
    @client_group = ClientGroup.new
  end

  def edit
    @companies = ClientCompany.all
    @client_group = ClientGroup.find(params[:id])
    @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
  end

  def update
    @client_group = ClientGroup.find(params[:id])
    if params[:client_group]
      @client_group.update_attributes(params[:client_group])
    elsif params[:accounts] && params[:accounts].size > 0
      if (params[:action_type] == "add")
        clients = Client.find(params[:accounts])
        clients.each{|client| @client_group.accounts << client if !@client_group.accounts.include?(client) }
      else
        accounts = []
        @client_group.accounts.each{|client| accounts << client if !params[:accounts].include?(client.id.to_s) }
        @client_group.accounts = accounts
      end
    end
    if @client_group.save
      flash[:info] = 'A client group has been updated successfully.'
      redirect_to(@client_group.admin_client_group_path)
    else
      @companies = ClientCompany.all
      render :action => "edit"
      @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
    end
  end

  def show
    @client_group = ClientGroup.find(params[:id])
    @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
  end

  def create
    @client_group = ClientGroup.new(params[:client_group])
    if @client_group.save
      flash[:info] = "A client group has been created successfully."
      redirect_to :action => "new"
    else
      @companies = ClientCompany.all
      render :action => "new"
    end
  end
  def confirm
    @client_group = ClientGroup.find_by_id(params[:id])
    if !@client_group
      flash[:notice] = "No client groups that fit ID: \"#{params[:id]}\""
    end
    @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
  end

  def destroy
    @client_group = ClientGroup.find_by_id(params[:id])
    if @client_group
      @client_group.destroy
      redirect_to admin_client_groups_path
    else
      flash[:notice] = "No client groups that fit ID: \"#{params[:id]}\""
      render :action => "confirm"
      @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
    end
  end
  def add_client
    @client_group = ClientGroup.find_by_id(params[:id])
    if @client_group
      non_candidate_clients = @client_group.accounts
      non_candidate_client_ids = non_candidate_clients.map{|x| x.id}
      if non_candidate_client_ids.size > 0
        @candidate_clients = Client.where("id not in(?)", non_candidate_client_ids)
      else
        @candidate_clients = Client.all
      end
    else
      flash[:notice] = "No client groups that fit ID: \"#{params[:id]}\""
    end
    @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
  end

  def remove_client
    @client_group = ClientGroup.find_by_id(params[:id])
    if @client_group
      @clients = @client_group.accounts
    else
      flash[:notice] = "No client groups that fit ID: \"#{params[:id]}\""
    end
    @dynamic_bottom_menu_items = client_group_dynamic_mnu_items(params[:id])
  end
  private
  def title_view
    @title_view = "Administration - Client group Management"
  end
end
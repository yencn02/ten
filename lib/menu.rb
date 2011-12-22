module Menu
  include AuthenticatedSystem
  module MenuStatus
    ACTIVE          = "active"
    INACTIVE        = "inactive"
    NEW_ITEM        = "newItem"
    NEW_ITEM_ACTIVE = "newItemActive"
  end

  def menu
    return unless logged_in?
    case current_account.read_attribute(:type)
    when Client.to_s
      build_client_menu
    when Worker.to_s
      if current_account.has_role?(Role::ADMIN)
        build_admin_menu
      else
        build_worker_menu
      end
    end
  end

  private
  
  def build_admin_menu
    build_admin_middle_menu
  end

  def build_client_menu
    # Create the top menu items
    @top_menu_items = [
      { :controller => "requests", :label => "Requirement",
        :status => MenuStatus::INACTIVE, :url => list_requests_by_project_path(:project_id => "all")},
      { :controller => "messages", :label => "Message",
        :status => MenuStatus::INACTIVE, :url => client_messages_path}
    ]
    @current_page = params[:page] || 1
    # Based on the controller path, set the corresponding menu item as active
    @top_menu_items.each do |item|
      if item[:controller] == controller_name
        item[:status] = MenuStatus::ACTIVE
        case item[:controller]
        when "requests"
          build_request_middle_menu()
        when "messages" # then build_message_priority_menu
          @active_top_menu_item = "Message"
          build_message_middle_menu()
        end
        break
      end
    end
  end

  def build_request_middle_menu
    @projects = Project.paginate_by_activity(current_account, "active", nil)
    @type = "request"
    build_request_bottom_menu
  end

  def build_request_bottom_menu
    project_id = params[:project_id] || "all"
    if project_id == "all"
      @bottom_menu_items = [{ :priority => "all", :label => "All",
          :status => MenuStatus::INACTIVE, :url => list_requests_by_project_path(:project_id => "all")}]
    else
      @bottom_menu_items = [
        { :priority => "all", :label => "All",
          :status => MenuStatus::INACTIVE, :url => list_requests_by_priority_path(:priority => "all", :project_id => project_id)},
        { :priority => action_name, :label => "New",
          :status => MenuStatus::INACTIVE, :url => new_client_request_path(:project_id => project_id)}
        ]
    end
    ClientRequest::PRIORITIES.each do |priority|
      @bottom_menu_items << {:priority => priority, :label => priority,
        :status => MenuStatus::INACTIVE, :url => list_requests_by_priority_path(:project_id => project_id, :priority => priority)}
    end
    priority = params[:priority] || "all"
    @bottom_menu_items.each do |item|
      if ["new", "create"].index(action_name) && item[:label] == "New"
        item[:status] = MenuStatus::ACTIVE
      elsif !["new", "create"].include?(action_name) && item[:priority] == priority
        item[:status] = MenuStatus::ACTIVE
      end
    end
  end

  # Create the top menu.
  def build_worker_menu
    # TODO Validate params[:page]
    @current_page = params[:page]
    
    @top_menu_items = [
      { :controller_names => ["tasks"],
        :label            => "Task",
        :status           => MenuStatus::INACTIVE,
        :url              => "/tasks/list/all"},
      { :controller_names => ["client_requests"],
        :label            => "Requirement",
        :status           => MenuStatus::INACTIVE,
        :url              => "/client_requests/project/all"},
      { :controller_names => ["messages"],
        :label            => "Message",
        :status           => MenuStatus::INACTIVE,
        :url              => "/messages/list"},
      { :controller_names => ["timesheets"],
        :label            => "Time",
        :status           => MenuStatus::INACTIVE,
        :url              => "/timesheets"} ,
      { :controller_names => ["projects"],
        :label            => "Project",
        :status           => MenuStatus::INACTIVE,
        :url              => "/projects" }
      ]

    if !current_account.has_role?(Role::MANAGER)
      @top_menu_items.delete_if { |x| ["Project", "Requirement"].index(x[:label]) }
    end

    # Based on the current controller name, set the corresponding menu item as active
    # and then build the corresponding middle menu
    @top_menu_items.each do |item|       
      if item[:controller_names].include?(controller_name)
        item[:status] = MenuStatus::ACTIVE
        worker_middle_menu(item)
        break
      end
    end


  end

  # Build the middle menu for the selected top menu item.
  def worker_middle_menu(parent_menu_item)
    case parent_menu_item[:label]
    when "Task"
      then build_task_middle_menu
    when "Requirement"
      then build_requirement_middle_menu
    when "Milestone"
      then build_milestone_middle_menu
    when "Message"
      then build_message_middle_menu
    when "Time"
      then build_time_middle_menu
    when "Project"
      then build_project_bottom_menu
    end
  end

  def build_requirement_middle_menu
    @projects = Project.paginate_by_activity(current_account, "active", nil)
    @type = "client_request"
    build_requirement_bottom_menu
  end

  def build_requirement_bottom_menu
    project_id = params[:project_id]|| "all"
    if project_id == "all"
      @bottom_menu_items = [{ :priority => "all", :label => "All",
          :status => MenuStatus::INACTIVE, :url => manager_list_requests_by_project_path(:project_id => "all")}]
    else
      @bottom_menu_items = [
        { :priority => "all", :label => "All",
          :status => MenuStatus::INACTIVE, :url => manager_list_requests_by_priority_path(:priority => "all", :project_id => project_id)},
        { :priority => "new", :label => "New",
          :status => MenuStatus::INACTIVE, :url => "/client_requests/new?project_id=#{project_id}"}
        ]
    end
    ClientRequest::PRIORITIES.each do |priority|
      @bottom_menu_items << {:priority => priority, :label => priority,
        :status => MenuStatus::INACTIVE, :url => manager_list_requests_by_priority_path(:project_id => project_id, :priority => priority)}
    end
    priority = params[:priority] || "all"
    @bottom_menu_items.each do |item|
      if ["new", "create"].index(action_name) && item[:label] == "New"
        item[:status] = MenuStatus::ACTIVE
      elsif !["new", "create"].include?(action_name) && item[:priority] == priority
        item[:status] = MenuStatus::ACTIVE
      end
    end
  end

  def build_time_middle_menu
    # Create menu items
    @middle_menu_items = [
      {:controller => "timesheets", :label => "Projects",
        :status => MenuStatus::INACTIVE, :url => "/timesheets/projects", :actions => ["projects", "list_by_project"]},
      {:controller => "timesheets", :label => "Workers",
        :status => MenuStatus::INACTIVE, :url => "/timesheets/workers", :actions => ["workers", "list_by_worker"]}
    ]
    @middle_menu_items.each do |item|
      if item[:actions].index(action_name)
        item[:status] = MenuStatus::ACTIVE
      end
    end
    if !["projects", "workers"].index(action_name)
      build_time_bottom_menu(action_name)
    end
  end

  def build_time_bottom_menu(action_name)
    @current_page = params[:page] || 1
    case action_name
    when "list_by_project"
      @bottom_menu_items = nil
      @projects = Project.paginate_by_activity(current_account, "active", nil)
      @type = "projects"
    when "list_by_worker"
      @bottom_menu_items = nil
      @selected_worker = params[:worker_id]
      @workers = Worker.paginate_by_activity(current_account, nil)
      @type = "workers"
    end
  end

  def build_admin_middle_menu
    @top_menu_items = [
      {:controller => "companies",
        :label => "Companies", :status => MenuStatus::INACTIVE, :url => "/admin/companies"},
      {:controller => "worker_groups",
        :label => "Worker Groups", :status => MenuStatus::INACTIVE, :url => "/admin/worker_groups"},
      {:controller => "workers",
        :label => "Workers", :status => MenuStatus::INACTIVE, :url => "/admin/workers"},
      {:controller => "client_companies",
        :label => "Client Companies", :status => MenuStatus::INACTIVE, :url => "/admin/client_companies"},
      {:controller => "client_groups",
        :label => "Client Groups", :status => MenuStatus::INACTIVE, :url => "/admin/client_groups"},
      {:controller => "clients",
        :label => "Clients", :status => MenuStatus::INACTIVE, :url => "/admin/clients"}
    ]

    @top_menu_items.each do |item|
      if item[:controller] == controller_name
        item[:status] = MenuStatus::ACTIVE
        build_admin_bottom_menu(item)
      end
    end
  end

  def build_admin_bottom_menu(parent_item)
    case parent_item[:controller]
    when "workers" then build_admin_bottom_menu_worker
    when "clients" then build_admin_bottom_menu_client
    when "companies" then build_admin_bottom_menu_companies
    when "client_companies" then build_admin_bottom_menu_client_companies
    when "worker_groups" then build_admin_bottom_menu_worker_groups
    when "client_groups" then build_admin_bottom_menu_client_groups
    end
    @middle_menu_items.each do |item|
      if item[:action].include?(action_name)
        item[:status] = MenuStatus::ACTIVE
      end
    end
  end

  def build_admin_bottom_menu_worker
    @middle_menu_items = [
      {:controller => "workers",
        :label => "All", :status => MenuStatus::INACTIVE, :url => "/admin/workers", :action => ["index"]},
      {:controller => "workers",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/admin/workers/new", :action => ["new", "create"]}
    ]
  end

  def build_admin_bottom_menu_client
    @middle_menu_items = [
      {:controller => "clients",
        :label => "All", :status => MenuStatus::INACTIVE, :url => "/admin/clients", :action => ["index"]},
      {:controller => "workers",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/admin/clients/new", :action => ["new", "create"]}
    ]
  end

  def build_admin_bottom_menu_companies
    @middle_menu_items = [
      {:controller => "companies",
        :label => "All", :status => MenuStatus::INACTIVE, :url => "/admin/companies", :action => ["index"]},
      {:controller => "companies",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/admin/companies/new", :action => ["new", "create"]}
    ]
  end

  def build_admin_bottom_menu_client_companies
    @middle_menu_items = [
      {:controller => "client_companies",
        :label => "All", :status => MenuStatus::INACTIVE, :url => "/admin/client_companies", :action => ["index"]},
      {:controller => "client_companies",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/admin/client_companies/new", :action => ["new", "create"]}
    ]
  end
  def build_admin_bottom_menu_worker_groups
    @middle_menu_items = [
      {:controller => "worker_groups",
        :label => "All", :status => MenuStatus::INACTIVE, :url => "/admin/worker_groups", :action => ["index"]},
      {:controller => "worker_groups",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/admin/worker_groups/new", :action => ["new", "create"]}
    ]
  end

  def build_admin_bottom_menu_client_groups
    @middle_menu_items = [
      {:controller => "client_groups",
        :label => "All", :status => MenuStatus::INACTIVE, :url => "/admin/client_groups", :action => ["index"]},
      {:controller => "client_groups",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/admin/client_groups/new", :action => ["new", "create"]}
    ]
  end

  #  def build_admin_bottom_menu_invoice
  #    @bottom_menu_items = nil
  #    @clients = Client.paginate_by_activity(current_account, @current_page)
  #    if params[:client_id].nil?
  #      # TODO What if most_active returns nil?
  #      @selected_client = Client.most_active(current_account).id
  #    else
  #      # TODO What if find_by_id returns nil?
  #      @selected_client = Client.find_by_id(params[:client_id], current_account).id
  #    end
  #  end
  #
  #  def build_admin_bottom_menu_project
  #    @bottom_menu_items = nil
  #    @projects = Project.paginate_by_activity(current_account, "active" ,@current_page)
  #    @type = "project"
  # end

  def build_project_bottom_menu
    @bottom_menu_items = [
      {:controller => "projects",
        :label => "New", :status => MenuStatus::INACTIVE, :url => "/projects/new", :action => "new", :rel => "facebox"},
      {:controller => "projects",
        :label => "Active", :status => MenuStatus::INACTIVE, :url => "/projects/active", :action => "active"},
      {:controller => "projects",
        :label => "Inactive", :status => MenuStatus::INACTIVE, :url => "/projects/inactive", :action => "inactive"}
    ]
    @bottom_menu_items.each do |item|
      if item[:action] == action_name
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
  end

  def build_message_middle_menu
    case current_account.read_attribute(:type)
    when Client.to_s
      url1 = "/client/messages/list/all"
      url2 = "/client/messages/list"
    when Worker.to_s
      url1 = "/messages/list/all"
      url2 = "/messages/list"
    end

    selected_status = get_selected_message_status()
    @bottom_menu_items = Array.new
    @bottom_menu_items << {:label => "All",
      :status => MenuStatus::INACTIVE, :url => url1}

    if selected_status == "all"
      @bottom_menu_items.first[:status] = MenuStatus::ACTIVE
    end

    Message::STATUSES.each do |status|
      item = {:label => status.id2name,
        :status => MenuStatus::INACTIVE, :url => "#{url2}/#{status.id2name}"}
      if status.id2name == selected_status
        item[:status] = MenuStatus::ACTIVE        
      end
      
      @bottom_menu_items << item
    end

  end

  def get_selected_message_status
    selected_status = params[:status]    
    if selected_status == nil || !Message::STATUSES.include?(selected_status.to_sym)
      selected_status = "all"
      params[:status] = selected_status
    end
    return selected_status
  end

  #
  # Collect the data required to build Milestone middle menu.
  #
  def build_milestone_middle_menu
    @middle_menu_items = nil
    @projects = Project.paginate_by_activity(current_account, "active", nil)
    @type = "milestone"
    build_milestone_bottom_menu()
  end

  def build_milestone_bottom_menu()
    new_item = {:label => "New", :status => MenuStatus::NEW_ITEM}
    if @current_page.nil?
      new_item[:url] = "/milestones/new"
    else
      new_item[:url] = "/milestones/new?page=#{@current_page}"
    end
    if params[:action] == "new"
      new_item[:status] = MenuStatus::NEW_ITEM_ACTIVE
    end

    @bottom_menu_items = Array.new
    @bottom_menu_items << new_item
  end

  def build_task_middle_menu
    @projects = Project.paginate_by_activity(current_account, "active", nil)
    set_active_project
    get_selected_task_status    
    @type = "task"
    build_task_bottom_menu
  end

  def build_task_bottom_menu
    task_statuses = Task.visible_task_statuses
    selected_task_status = nil
    project_id = params[:project_id]|| "all"
    @bottom_menu_items = Array.new        
    selected_task_status = get_selected_task_status
    
    # Add menu items for task statuses
    task_statuses.each do |status|    
      bottom_menu_item = {
        :label => status, :status => status == selected_task_status ? MenuStatus::ACTIVE : MenuStatus::INACTIVE,
        :url => {:controller => "tasks", :action => "list", :status => status, :project_id => params[:project_id]} #params.merge(:status => status),
      }      
      @bottom_menu_items << bottom_menu_item
    end
    if current_account.has_role?(Role::MANAGER) || current_account.has_role?(Role::LEAD)
      if project_id != "all"
        new_item = {:label => "New", :status => MenuStatus::NEW_ITEM}
        new_item[:url] = "/client_requests/new"
        @bottom_menu_items.insert(1, new_item)
      end
    end
    @bottom_menu_items
    
  end

  def get_selected_task_status       
    session[:active_task_status] = params[:status] || "all"
    return session[:active_task_status]
  end
  #
  # Resolve the active project.
  #
  def set_active_project 
    if params[:project_id].nil?
      if session[:active_project].nil?
        active_project = Project.most_active(current_account)
        unless active_project.nil?
          session[:active_project] = active_project.id
        end
      end
    else
      session[:active_project] = params[:project_id]
    end
  end

  def worker_dynamic_mnu_items(worker_id, login_id)
    edit = { :controller => "workers", :label => "Edit", :status => MenuStatus::INACTIVE,
      :url => "/admin/workers/#{worker_id}/edit", :action => ["edit", "update"] }
    show = { :controller => "workers", :label => "Worker Details", :status => MenuStatus::INACTIVE,
      :url => "/admin/workers/#{worker_id}", :action => ["show"] }
    destroy = { :controller => "workers", :label => "Remove", :status => MenuStatus::INACTIVE,
      :url => "/admin/workers/confirm/#{worker_id}", :action => ["destroy", "confirm"]}
    menu_items = [show, edit]
    menu_items << destroy if login_id.to_s != worker_id
    menu_items.each do |item|
      if item[:action].include?(params[:action])
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
    return menu_items
  end

  def client_dynamic_mnu_items(client_id)
    edit = { :controller => "clients", :label => "Edit", :status => MenuStatus::INACTIVE,
      :url => "/admin/clients/#{client_id}/edit", :action => ["edit", "update"] }
    show = { :controller => "clients", :label => "Client Details", :status => MenuStatus::INACTIVE,
      :url => "/admin/clients/#{client_id}", :action => ["show"] }
    destroy = { :controller => "clients", :label => "Remove", :status => MenuStatus::INACTIVE,
      :url => "/admin/clients/confirm/#{client_id}", :action => ["destroy", "confirm"]}
    menu_items = [show, edit, destroy]
    menu_items.each do |item|
      if item[:action].include?(params[:action])
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
    return menu_items
  end

  def client_company_dynamic_mnu_items(company_id, enabled)
    edit = { :controller => "client_companies", :label => "Edit", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_companies/#{company_id}/edit", :action => ["edit"] }
    show = { :controller => "client_companies", :label => "Client Company Details", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_companies/#{company_id}", :action => ["show"] }
    status_label = "Activate"
    status_label = "Deactivate" if enabled == true
    status = { :controller => "client_companies", :label => status_label, :status => MenuStatus::INACTIVE,
      :url => "/admin/client_companies/confirm_status/#{company_id}", :action => ["confirm_status", "set_status"] }
    destroy = { :controller => "client_companies", :label => "Remove", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_companies/confirm_remove/#{company_id}", :action => ["destroy", "confirm_remove"]}
    menu_items = [show, edit, destroy, status]
    menu_items.each do |item|
      if item[:action].include?(params[:action])
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
    return menu_items
  end

  def company_dynamic_mnu_items(company_id, enabled)
    edit = { :controller => "companies", :label => "Edit", :status => MenuStatus::INACTIVE,
      :url => "/admin/companies/#{company_id}/edit", :action => ["edit", "update"] }
    show = { :controller => "companies", :label => "Company Details", :status => MenuStatus::INACTIVE,
      :url => "/admin/companies/#{company_id}", :action => ["show"] }
    status_label = "Activate"
    status_label = "Deactivate" if enabled == true
    status = { :controller => "companies", :label => status_label, :status => MenuStatus::INACTIVE,
      :url => "/admin/companies/confirm_status/#{company_id}", :action => ["confirm_status", "set_status"] }
    destroy = { :controller => "companies", :label => "Remove", :status => MenuStatus::INACTIVE,
      :url => "/admin/companies/confirm_remove/#{company_id}", :action => ["destroy", "confirm_remove"]}
    menu_items = [show, edit, destroy, status]
    menu_items.each do |item|
      if item[:action].include?(params[:action])
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
    return menu_items
  end

  def worker_group_dynamic_mnu_items(group_id)
    edit = { :controller => "worker_groups", :label => "Edit", :status => MenuStatus::INACTIVE,
      :url => "/admin/worker_groups/#{group_id}/edit", :action => ["edit", "update"] }
    show = { :controller => "worker_groups", :label => "Worker Group Details", :status => MenuStatus::INACTIVE,
      :url => "/admin/worker_groups/#{group_id}", :action => ["show"] }
    add_worker = { :controller => "worker_groups", :label => "Add Worker", :status => MenuStatus::INACTIVE,
      :url => "/admin/worker_groups/add_worker/#{group_id}", :action => ["add_worker"] }
    remove_worker = { :controller => "worker_groups", :label => "Remove Worker", :status => MenuStatus::INACTIVE,
      :url => "/admin/worker_groups/remove_worker/#{group_id}", :action => ["remove_worker"] }
    destroy = { :controller => "worker_groups", :label => "Remove", :status => MenuStatus::INACTIVE,
      :url => "/admin/worker_groups/confirm/#{group_id}", :action => ["destroy", "confirm"]}
    menu_items = [show, edit, destroy, add_worker, remove_worker]
    menu_items.each do |item|
      if item[:action].include?(params[:action])
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
    return menu_items
  end

  def client_group_dynamic_mnu_items(group_id)
    edit = { :controller => "client_groups", :label => "Edit", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_groups/#{group_id}/edit", :action => ["edit", "update"] }
    show = { :controller => "client_groups", :label => "Client Group Details", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_groups/#{group_id}", :action => ["show"] }
    add_worker = { :controller => "client_groups", :label => "Add Client", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_groups/add_client/#{group_id}", :action => ["add_worker"] }
    remove_worker = { :controller => "client_groups", :label => "Remove Client", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_groups/remove_client/#{group_id}", :action => ["remove_worker"] }
    destroy = { :controller => "client_groups", :label => "Remove", :status => MenuStatus::INACTIVE,
      :url => "/admin/client_groups/confirm/#{group_id}", :action => ["destroy", "confirm"]}
    menu_items = [show, edit, destroy, add_worker, remove_worker]
    menu_items.each do |item|
      if item[:action].include?(params[:action])
        item[:status] = MenuStatus::ACTIVE
        break
      end
    end
    return menu_items
  end
end
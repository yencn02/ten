  module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home page/
      "/"

    when /the client request list page/    
      '/client/requests/project/all'
      
    when /the list workers page/
      'client_requests/list'
      
      
     when /the client message list page/
     '/client/messages/list/all'

    when /the all tasks page/      
      '/tasks/list/all'
    
    when /the timesheet list page/        
      "/timesheets"

    when /the timesheet list project/
      "/timesheets/projects"
    when /the timesheet list worker/
      "/timesheets/workers"
      
    when /all messages page/
      '/messages/list'
      
    when /the read messages page/
      '/messages/list/read'
      
    when /the unread messages page/
      '/messages/list/unread'
      
     when /the archived messages page/
      '/messages/list/archived'
    
    when /the new message page/
      
			
    when /the milestones page/
      '/milestones/list'
			
    when /new task page/
      '/tasks/new'
    
    when /the task list page/
      '/tasks/list/all'
      
    when /all requests page/
      '/client_requests/list/' + @project.id.to_s

    when /new request page/
      '/client_requests/new/' +  @project.id.to_s

    when /the client request view page of "([^\"]*)"/
      client_request = ClientRequest.find_by_title($1)
      '/client/requests/' + client_request.id.to_s

    when /show request page for "([^\"]*)"/
      client_request = ClientRequest.find_by_title($1)
      if(@current_account.is_a? Client) then 
        'client/requests/' + client_request.id.to_s
      else
        '/client_requests/' + client_request.id.to_s
      end
    when /the client request view page for "([^\"]*)"/
      client_request = ClientRequest.find_by_title($1)
      '/client/requests/' + client_request.id.to_s
    when /the project list page/
      projects_path
      
    when /the project edit page for "([^\"]*)/
      project = Project.find_by_name($1)
      'projects/edit/' + project.id.to_s
      
    when /the task view page of "([^\"]*)"/      
      task = Task.find_by_title($1)
      '/tasks/' + task.id.to_s
      
    when /the task view of the project "([^\"]*)"/
      project = Project.find_by_name($1)
      '/tasks/list/' + project.id.to_s + "/all/"
    when /list worker groups/
      admin_worker_groups_path
    when /the list workers/
      admin_workers_path
    when /list worker/
      admin_workers_path
    when /show worker group/
      if @worker_group
        "/admin/worker_groups/#{@worker_group.id}"
      else
        
      end
    when /show worker/
      "/admin/workers/#{@worker.id}"
    when /edit worker/
      "/admin/workers/#{@worker.id}/edit"
    when /list clients/
      admin_clients_path
    when /show client company/
      "/admin/client_companies/#{@client_company.id}"
    when /show client/
      "/admin/clients/#{@client.id}"
    when /edit client/
      "/admin/clients/#{@client.id}/edit"
    when /list companies/
      admin_companies_path
    when /list client companies/
      admin_client_companies_path
    when /confirm client company activation/
      "/admin/client_companies/#{@client_company.id}/confirm/activate"
    when /confirm client company deactivation/
      "/admin/client_companies/#{@client_company.id}/confirm/deactivate"
    when /confirm group removal/
      "/admin/worker_groups/confirm/#{@worker_group.id}"
    when /my account/
      "/accounts/#{@current_account.id}"
    when /client account/
      "/accounts/#{@client.id}"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)

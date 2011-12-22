Given /^I have the following client requests:$/ do |table|
  project = Factory(:project,:worker_group => @current_account.worker_groups[0])
  client = Factory(:client, :client_groups => [project.client_group])
  table.hashes.each do |hash|
    cr = Factory(:client_request, 
      :title => hash[:title],
      :description => hash[:description],
      :priority => ClientRequest.priority_value_for(hash[:priority]),
      :status => hash[:status],
      :created_at => DateTime.strptime(hash[:created_at],"%m/%d/%Y"),
      :milestone => Factory(:milestone,:project => project, :title => hash[:milestone]),       
      :client => client)
    Factory(:task, :title => "name", :client_request => cr, :project => project)
  end  
end

Given /^project "([^\"]*)" has at least one milestone$/ do |name|
  project = Project.find_by_name(name)
  Factory(:milestone, :project => project)
end

Then /^I should see the following workers:$/ do |table|
  table.hashes.each do |hash|
    page.should have_content(hash[:login])
  end
end

Given /^the worker "([^\"]*)" has the least assigned hours among other workers$/ do |login|
  worker = Worker.find_by_login(login)
end

Then /^I should see "([^\"]*)" in the task list of the worker "([^\"]*)"$/ do |title, login|
  #the contrainst should be more specific here...
end

Given /^I have a client request with a title of "([^\"]*)"$/ do |title|
  project = Factory(:project,:worker_group => @current_account.worker_groups[0])
  client = Factory(:client, :client_groups => [project.client_group])
  client_request = Factory(:client_request,
      :title => title,
      :created_at => Time.now - 1.day,
      :milestone => Factory(:milestone,:project => project), 
      :client => client)
  Factory(:task, :title => title, :client_request => client_request, :project => project)
end

Given /^the client request "([^\"]*)" includes the change "([^\"]*)"$/ do |request, change|
   client_request = ClientRequest.find_by_title(request)
    Factory(:client_request_change, 
      :client_request => client_request, 
      :description => change)
end

Given /^the client request "([^\"]*)" includes the following files:$/ do |request, table|
  client_request = ClientRequest.find_by_title(request)
  table.hashes.each do |hash|
    af = AttachedFile.new
    af.description = hash[:description]
    af.file_file_name =  hash[:filename]
    af.file_file_size = 1000
    af.file_content_type = "unknown"
    af.created_at = Time.now - 1.day
    af.client_request = client_request
    af.save!
  end
end

Then /^I should see the following files on the change files panel:$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:filename]}\""
    Then "I should see \"#{hash[:description]}\""
  end
end

Given /^the client request "([^\"]*)" includes the file "([^\"]*)" which description is "([^\"]*)"$/ do |request, filename, description|
  client_request = ClientRequest.find_by_title(request)
  af = AttachedFile.new
  af.description = description
  af.file_file_name =  filename
  af.file_file_size = 1000
  af.file_content_type = "unknown"
  af.created_at = Time.now - 1.day
  af.client_request = client_request
  af.save!
end

When /^I follow "Delete" to remove "([^\"]*)" on "files__client_request" panel$/ do |filename|
  file = AttachedFile.find_by_filename(filename)
  visit "attached_files/delete/#{file.id}?afp=1&idSuffix=__client_request"  
end

When /^I follow "Delete" to remove "([^\"]*)" change$/ do |title|
  change = ClientRequestChange.find_by_description(title)
  visit "client_requests/delete_change/#{change.id}"
end

When /^I fill in the description with "([^"]*)" for a change of "([^"]*)"$/ do |value, object|
  page.evaluate_script("tinyMCE.editors.description.setContent('#{value}')")
end

When /^I fill in the "([^"]*)" with "([^"]*)"$/ do |field, value|
  page.evaluate_script("tinyMCE.editors.#{field}.setContent('#{value}')")
end

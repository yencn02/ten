Given /^I have at least one project$/ do
  @project = Factory.create(:project, 
    :worker_group => Factory(:worker_group), 
    :client_group => @client.client_groups[0])
  @milestone = Factory.create(:milestone, :project => @project)  
end


When /^I fill in "([^\"]*)" with ([^\"]*)$/ do |textfield, value| 
  fill_in(textfield, :with => value)
end

When /^I follow "Request" link$/ do |link|   
  click_link(link)
end

Then /^I should go to the "all requests" page$/ do
  current_url.should =~ /client_requests\/list\//
end

Given /^I have a request titled "([^\"]*)" with "priority" of "([^\"]*)"$/ do |title, priority|
  @client_request = Factory.create(:client_request, 
    :title => title,
    :milestone => @milestone,
    :priority => ClientRequest::priority_value_for(priority))
end

Then /^I should see "([^\"]*)" with a priority of (.+)$/ do |title, priority|
  response.should have_selector("tr", :request_id => @client_request.id.to_s) do |tr|
    tr.should have_selector("td", :content =>title)  
    tr.should have_selector("td", :content =>priority)  
  end
end

Given /^I have a request titled "([^\"]*)" with "state" of "([^\"]*)"$/ do |title, state|
  @client_request = Factory.create(:client_request, 
    :title => title,
    :milestone => @milestone,
    :status => state)
end

Then /^I should see "([^\"]*)" with a state of (.+)$/ do |title, state|
  response.should have_selector("tr", :request_id => @client_request.id.to_s) do |tr|
    tr.should have_selector("td", :content =>title)  
    tr.should have_selector("td", :content =>state)  
  end
end

Given /^I have the following requests$/ do |table|
  table.hashes.each do |hash|    
    project = Project.find_by_name(hash[:project])
    project = Factory.create(:project, :client_group => @client.client_groups[0], :name => hash[:project]) if project.nil?
    milestone = Factory.create(:milestone, :project => project)
    priority = ClientRequest::priority_value_for(hash[:priority].to_s)
    client_request =Factory(:client_request, :title => hash[:title],  :description => hash[:description],
      :milestone => milestone, :priority => priority, :created_at => Time.now - 1.day, :status => hash[:state])
    Factory(:task, :title => "name", :client_request => client_request, :project => project)
  end
end

Given /^I have the following requests:$/ do |table|
  table.hashes.each do |hash|    
    project = Project.find_by_name(hash[:project])
    project = Factory.create(:project, :client_group => @client.client_groups[0], :name => hash[:project]) if project.nil?
    milestone = Factory.create(:milestone, :project => project)
    client_request = Factory(:client_request, :title => hash[:title],  :description => hash[:description], :milestone => milestone)
    Factory(:task, :title => "name", :client_request => client_request, :project => project)
  end
end


Then /^I should see the following requests$/ do |table|  
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:project]}\""
    Then "I should see \"#{hash[:title]}\""
    Then "I should see \"#{hash[:priority]}\""
    Then "I should see \"#{hash[:description]}\""
  end
end



Given /^I have the following changes for the request "([^\"]*)"$/ do |title, table|
  project = Factory.create(:project, :client_group => @client.client_groups[0])  
  milestone = Factory.create(:milestone, :project => project)    
  client_request = Factory(:client_request, :title => title, :milestone => milestone)
  Factory(:task, :title => "name", :client_request => client_request, :project => project)
  table.hashes.each do |hash|    
    Factory(:client_request_change, :description => hash[:description], :client_request => client_request, :created_at => hash[:created_at])
  end
end

Then /^I should see the following request changes$/ do |table|
  table.hashes.each do |hash|    
   # Then "I should see \"#{Time.parse(hash[:created_at]).strftime("%b/%d/%Y")}\""
    Then "I should see \"#{hash[:description]}\""
  end
end

Given /^I have the following change for the request "([^\"]*)"$/ do |title, table|
  project = Factory.create(:project, :client_group => @client.client_groups[0])  
  milestone = Factory.create(:milestone, :project => project)    
  client_request = Factory(:client_request, :title => title, :milestone => milestone)
  Factory(:task, :title => "name", :client_request => client_request, :project => project)
  table.hashes.each do |hash|    
    Factory(:client_request_change, :description => hash[:description], :client_request => client_request)
  end
end

Given /^I have the following attached files for the request "([^\"]*)"$/ do |title, table|
  project = Factory.create(:project, :client_group => @client.client_groups[0])  
  milestone = Factory.create(:milestone, :project => project)    
  client_request = ClientRequest.find_by_title(title)
  Factory(:task, :title => "name", :client_request => client_request, :project => project)
  table.hashes.each do |hash|    
    file = Factory(:attached_file, :description => hash[:Description], :file_file_name => hash[:Description], :client_request => client_request, :created_at => hash[:created_at])
  end
end

Then /^I should see the following attached files$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:Description]}\""
    Then "I should see \"#{hash[:created_at]}\""
  end
end

When /^I attach the file at "([^"]*)" to "([^"]*)"$/ do |path, field|
  And "I attach the file \"#{Rails.root + path}\" to \"#{field}\""
end

When /^I fill in the note with "([^"]*)" of attached file for "([^"]*)"$/ do |value, object|
  suffix = object.downcase.gsub(" ", "_")
  page.evaluate_script("tinyMCE.editors.fileNote__#{suffix}.setContent('#{value}')")
end

When /^I fill in the message with "([^"]*)" of client discusstion for "([^"]*)"$/ do |message, object|
  page.evaluate_script("tinyMCE.editors.client_message_body.setContent('#{message}')")
end


When /^I change the text "([^"]*)" of the attached file to "([^"]*)"$/ do |old_value, new_value|
  file = AttachedFile.find_by_description(old_value)
  page.evaluate_script("tinyMCE.editors.textarea_file_description_#{file.id}_in_place_editor.setContent('#{new_value}')")
end

When /^I change the text "([^"]*)" of the change to "([^"]*)"$/ do |old_value, new_value|
  change = ClientRequestChange.find_by_description(old_value)
  page.evaluate_script("tinyMCE.editors.textarea_change_description_#{change.id}_in_place_editor.setContent('#{new_value}')")
end

When /^I click the "([^"]*)" link to delete$/ do |link|
  page.evaluate_script('window.confirm = function() { return true; }')
  Then "I follow \"Delete\""
  page.evaluate_script('window.location = window.location.href;')
end

When /^I click the text "([^"]*)" of the attached file$/ do |description|
  file = AttachedFile.find_by_description(description)
  find("#file_description_#{file.id}_in_place_editor").click
end

When /^I click the text "([^"]*)" of the change$/ do |description|
  change = ClientRequestChange.find_by_description(description)
  find("#change_description_#{change.id}_in_place_editor").click
end

Given /^I have the request "([^\"]*)"$/ do |name|  
  project = Factory.create(:project, :client_group => @client.client_groups[0])
  milestone = Factory.create(:milestone, :project => project)
  client_request = Factory(:client_request, :title => name,  :description => name, :milestone => milestone)
  Factory(:task, :title => name, :client_request => client_request, :project => project)
end

Given /^I have the following messages for the request "([^\"]*)"$/ do |title, table|
  project = Factory.create(:project, :client_group => @client.client_groups[0])  
  milestone = Factory.create(:milestone, :project => project)    
  client_request = Factory(:client_request, :title => title, :milestone => milestone)
  Factory(:task, :title => title, :client_request => client_request, :project => project)
  table.hashes.each do |hash|
    sender = Factory(:client, :login => hash[:sender], :name => hash[:sender] )
    Factory(:client_message, :title => hash[:message], :body => hash[:message],
      :sender => sender, :client_request => client_request, :created_at => hash[:created_at])
  end
end

Then /^I should see the following messages$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:sender]}\""
    Then "I should see \"#{hash[:message]}\""
  end
end

Given /^I have the message "([^\"]*)" for the request "([^\"]*)"$/ do |message, request|  
  client_request = ClientRequest.find_by_title(request)    
  Factory(:client_message, :client_request => client_request, :title => message, :body => message, :sender => @client)
end

Given /^I have the project "([^"]*)"$/ do |name|   
  project = Factory(:project, :name => name, :client_group => @client.client_groups[0])
  Factory(:milestone, :project => project)
end

Then /^I should see "([^"]*)" with value "([^"]*)"$/ do |priority, value|
  Then "I should see \"#{priority}\""
  Then "I should see \"#{value}\""
end


Given /^I have the below message for the request "([^"]*)"$/ do |client_request, string|
  client_request = ClientRequest.find_by_title(client_request)
  Factory(:client_message, :client_request => client_request, :sender => @client, :body => string)
end

When /^I click on the title of message "([^"]*)"$/ do |arg1|
  page.evaluate_script("$(\".content\").toggle();")
end

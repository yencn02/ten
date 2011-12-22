Given /^project "([^\"]*)" has a client request and associated task$/ do |name|
  project = Project.find_by_name(name)
  @client = Factory(:client, :client_groups => [project.client_group])
  @client_request = Factory(:client_request, :client => @client,
      :milestone => Factory(:milestone,:project => project))
  @worker = Factory(:worker, :login => "Coworker", :worker_groups => @current_account.worker_groups)      
  @task = Factory(:task, :client_request => @client_request, :worker => @worker, :project => project)
end

Given /^I have the following messages:$/ do |table|
  table.hashes.each do |hash|
    message = Factory(:message, :title => hash[:title], :body => hash[:title], :sender => @worker, :task => @task) 
    Message.init_message_status(message, hash[:status])
  end
end

Given /^I have following client messages:$/ do |table|
  table.hashes.each do |hash|
    message = Factory(:client_message,
      :sender => @client,
      :body => hash[:title],
      :client_request => @client_request)
    ClientMessage.init_message_status(message, hash[:status])
  end
end

Then /^I should see the following messages:$/ do |table|
  table.hashes.each do |hash|
    if(hash[:font] == "bold") then 
      page.should have_css(".unread_status")
    else      
      page.should have_css(".messageItem")    
    end
  end
end


Then /^I should not see the following messages:$/ do |table|
  table.hashes.each do |hash|    
      page.should_not have_content(hash[:title])
  end
end

Then /^I should go to the task edit page that "([^\"]*)" client message belongs to$/ do |msg|
  client_message = ClientMessage.find_by_body(msg) 
  current_url.should edit_task_path(client_message.client_request.task)
end

Then /^I should go to the task edit page that "([^\"]*)" message belongs to$/ do |msg|
  message = Message.find_by_body(msg)  
  current_url.should edit_task_path(message.task)
end

Then /^I should go to the task show page that "([^"]*)" message belongs to$/ do |msg|
  message = Message.find_by_body(msg)  
  current_url.should =~ /tasks/#{message.task.id}/
end

When  /^I check on the message "([^"]*)"$/ do |msg|
 
end


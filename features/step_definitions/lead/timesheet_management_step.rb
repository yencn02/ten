Given /^the project "([^\"]*)" includes the following timesheet entries:$/ do |project, table|
  project = Project.find_by_name(project)
  milestone = Factory.create(:milestone, :project => project)
  table.hashes.each do |hash|
    client_request = Factory.create(:client_request, :title => hash[:task], :milestone => milestone)
    worker = (hash[:status] != Task::UNASSIGNED)? @current_account : nil
    task = Factory(:task, :project => project,
      :title => hash[:task],
      :client_request => client_request,
      :worker => @current_account,
      :estimated_hours => hash[:hours])    
  end
 

end

Given /^the worker "([^\"]*)" is a member of the project "([^\"]*)"$/ do |worker, project|
  project = Project.find_by_name(project)  
  Factory(:worker, :login => worker, :name => worker, :email => worker + '@company.com',:worker_groups => @current_account.worker_groups)
  
end

Given /^the worker "([^\"]*)" has created the following timesheet entries:$/ do |worker, table|
  worker_account = Worker.find_by_name(worker)
  project = Project.find_by_worker_group_id(worker_account.worker_groups)

  milestone = Factory.create(:milestone, :project => project)
  table.hashes.each do |hash|
    client_request = Factory.create(:client_request, :title => hash[:task], :milestone => milestone) 
    worker = (hash[:status] != Task::UNASSIGNED)? worker_account : nil    
    task = Factory(:task, :project => project, 
      :title => hash[:task], 
      :client_request => client_request,
      :worker => worker,
      :estimated_hours => hash[:hours])
  end  
end


Then /^I should see the following$/ do |table|    
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:project]}\""
  end
end



Then /^I should see the following task:$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:task]}\""
  end
end

Then /^I should see the following login:$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:login]}\""
  end
end


When /^I follow on "([^"]*)"$/ do |action|
  click_link action
end



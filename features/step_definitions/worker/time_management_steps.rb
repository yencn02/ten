Given /^I already have a task called "([^\"]*)" that has "([^\"]*)" hours completed of "([^\"]*)" hours estimated$/ do |title, complete, estimate|
  @task = Factory.build(:task, :title => title, :estimated_hours => estimate,:worker => @current_account)
  @task.project = Factory.create(:project, :worker_group => @current_account.worker_groups[0])
  #create milestone, client_request, client_request change 
  milestone = Factory.create(:milestone, :project => @task.project)
  client_request = Factory.create(:client_request, :milestone => milestone)
  Factory.create(:client_request_change, :client_request => client_request)  
  @task.client_request = client_request
  @task.save!
  if(complete.to_i >0) then
    Factory.create(:billable_time, :billed_hours => estimate, :task => @task)
  end
end

When /^I click on the time icon for "([^\"]*)"$/ do |task|
  @task = Task.find_by_title(task)
  within("#task#{@task.id}") {
    click_link("clock#{@task.id}")
  }
end

Then /^I should see the time panel drop down$/ do
  Then "I should see \"Billed Hours\""
  Then "I should see \"Complete\""
end

Then /^I should see that the project image is "([^\"]*)" percent complete$/ do |percent|
  with_scope("#task#{@task.id}") do
    field = find(:xpath, "/td/input[@name='complete']")
    field_value = field.value
    field_value.should =~ /#{percent}/
  end
end

Then /^I should not see the time icon for "([^\"]*)"$/ do |task_title|  
  task = Task.find_by_title(task_title)
  with_scope("#task" + task.id.to_s) do
    field = find(:xpath, "/img[@class='clock']")
    field.should == nil
  end
end

Then /^I should see that the completed hours is "([^\"]*)" of "([^\"]*)" estimated$/ do |complete, estimate|
  Then "I should see \"#{complete}\""
  And "I should see \"#{estimate}\""
end

When /^I fill in the description of "([^"]*)" with "([^"]*)"$/ do |task, description|
  task = Task.find_by_title(task)
  with_scope("#task" + task.id.to_s) do
    field = find("#description#{task.id}")
    field.set(description)
  end
end

When /^I fill in the billed hour of "([^"]*)" with "([^"]*)"$/ do |task, hour|
  task = Task.find_by_title(task)
  with_scope("#task" + task.id.to_s) do
    field = find("#billed_hour#{task.id}")
    field.set(hour)
  end
end

When /^I fill in commit hash of "([^"]*)" with "([^"]*)"$/ do |task, commit_hash|
  task = Task.find_by_title(task)
  with_scope("#task" + task.id.to_s) do
    field = find("#commit_hash#{task.id}")
    field.set(commit_hash)
  end
end


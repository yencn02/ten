Given /^I am assigned to a complete project called "([^\"]*)"$/ do |name|
  @task = Factory.build(:task, :title => "Test Task A",:worker => @current_account)
  @project = Factory.create(:project, :name => name, :worker_group => @current_account.worker_groups[0]) 
  @task.project = @project
  @project.save!
  # create milestone, client_request, client_request change 
  milestone = Factory.create(:milestone, :project => @project)
  client_request = Factory.create(:client_request, :milestone => milestone) 
  @task.client_request = client_request
  @task.save!
		
  # worker discussion message
  Factory.create(:message, :title => "Message for #{@task.title}",:task => @task, :sender => @current_account)  
  # client and client discussion message
  client = Factory.create(:client, :client_groups => [@project.client_group])
  Factory.create(:client_message, :title => "Customer message", :sender => client, :client_request => client_request)
end


Then /^I should see all tasks assigned to my group$/ do
  worker_ids = @current_account.worker_ids.join(",")
  count = Task.count_by_sql "SELECT COUNT(*) FROM tasks t WHERE t.worker_id in (#{worker_ids})"
  response.should have_selector("tr.bottomBorder" , :count => count)
end

Then /^I should see all tasks assigned to me$/ do
  count = Task.count_by_sql "SELECT COUNT(*) FROM tasks t WHERE t.worker_id = #{@current_account.id.to_s}"
  response.should have_selector("td.Login" , :content => @current_account.login, :count => count)  
end

When /^I click on the "([^\"]*)" link$/ do |link|
  click_link link
end

When /^I click on the ([^\".]+) status$/ do |status|
  #  within "ul#bottom" do
  #    click_link status
  visit "/tasks/list/#{status.downcase}"
  #  end

end

When /^I click on the ([^\".]+) project$/ do |project|
  #  within "div#projectList" do
  #    click_link project
  visit "/tasks/list/all"
  #  end
end


Then /^I should see all (.+) for (.+)$/ do |status, project|
  proj = Project.find_by_name(project)
  tasks = []
  case status
  when 'OPEN'
    tasks = proj.open_tasks
  when 'ESTIMATED'
    tasks = proj.estimated_tasks
  when 'ASSIGNED'
    tasks = proj.assigned_tasks
  when 'COMPLETE'
    tasks = proj.complete_tasks
  when 'VERIFIED'
    tasks = proj.verified_tasks
  when 'ALL'
    tasks = proj.tasks
  end
  tasks.each do |task|
    page.should have_content(task.title)
  end
end



Then /^I should see the task show view for "([^\"]*)"$/ do |task|
  #  page.should has_selector?("h3#taskTitle", :content => task)
  page.should have_content(task)


end

Then /^I should see at least one change record$/ do
  page.has_css?('div#changes div#changes_request').should be_true
end

Then /^I should not be able to add a new change$/ do
  page.should have_no_xpath("a[@id='new-change']", :content => "Add new")
end

When /^I add a "([^\"]*)" file attachment$/ do |file|
  within "div#fileList__task" do
   click_link("New")
  end  
  within "div#newFile__task" do   
    path = "#{Rails.root + file}"    
    attach_file("attachedFile__task[file]", path)
    page.evaluate_script("tinyMCE.editors.fileNote__task.setContent('Note for attachment')")
    click_button "Create"
  end
end

Then /^I should see the "([^\"]*)" attached file$/ do |file| 
   page.should have_content(file)
end

Then /^I should see at least one client discussion message$/ do  
  page.has_css?('div#client-message-list div.message').should be_true
end

When /^I add a technical note "([^"]*)"$/ do |text|
  within "div#technical-notes" do
    click_link('New')
    fill_in("Description", :with => text)
    click_button "Create"
  end  
end

Then /^I should be able to see the technical note "([^"]*)"$/ do |text|
  page.should have_content(text)
end



Then /^I should be able to see the technical note$/ do
  within "div#noteList" do |noteList|
    noteList.should have_selector("div.reqChange")
  end
end

When /^I add the message "([^\"]*)"$/ do |message|
  with_scope('div#messages_developer div.new') do
    click_link('New')
  end  
  page.evaluate_script("tinyMCE.editors.message_body.setContent('#{message}')")  
  with_scope('div#messages_developer') do
    click_button('Create')
  end
end

Then /^I should be able to see the message "([^\"]*)"$/ do |message|
  page.should have_content(message)
end

When /^I reply to the "([^\"]*)" message with "([^\"]*)"$/ do |msg, remsg|
  with_scope('div#messages_developer div.new') do
    click_link('New')
  end
  fill_in("message_body", :with => remsg)
end


When /^I delete the message "([^\"]*)"$/ do |msg|
  message = Message.find_by_body(msg)  
  message.should_not be_nil   
  visit "/messages/delete_message/#{message.id}"
  visit "/tasks/#{message.task.id}"
end

Then /^I should not see the message "([^\"]*)"$/ do |message|
  Then "I should not see \"#{message}\""
end

Given /^my project has unassigned task with the title of "([^\"]*)"$/ do |task_title|
  client_request = Factory.create(:client_request, 
    :status => "new",
    :milestone => Factory(:milestone, :project => @project))
  @task = Factory(:task, :title => task_title, :status => "open", :project => @project, :client_request => client_request)
end

When /^I follow "([^\"]*)" on "([^\"]*)"$/ do |action, task_title|
  task = Task.find_by_title(task_title)  
   with_scope "tr#task#{task.id}" do
    click_link action
  end
end

Then /^I should see the task assigned to me with "([^\"]*)" hours of estimated$/ do |estimated_hours|
  page.should have_content(estimated_hours)
end

When /^I click on the "([^\"]*)" link for "([^\"]*)"$/ do |action, section|
  case section
  when "Changes"
    click_link "Changes"
  when "Client Discussion"
    click_link "client discussion"
  when "Technical Notes"
    click_link('technical notes')
  when "Developer Discussion"
    click_link "developer discussion"
  end
end

Then /^I should not see the "([^"]*)" section$/ do |section|  
  case section
  when "Changes"
    page.has_css?("div#changes_request[style='display: none;']").should be_true
  when "Client Discussion"
    page.has_css?("div#messages_client[style='display: none;']").should be_true
  when "Technical Notes"
    page.has_css?("div#notes[style='display: none;']").should be_true
  when "Developer Discussion"
    page.has_css?("div#messages_developer[style='display: none;']").should be_true
  end
end

Then /^I should see the "([^\"]*)" section$/ do |section|   
  case section
  when "Changes"
    page.has_css?("div#changes_request[style='display: none;']").should be_false
  when "Client Discussion"
    page.has_css?("div#message_client[style='display: none;']").should be_false
  when "Technical Notes"
    page.has_css?("div#notes[style='display: none;']").should be_false
  when "Developer Discussion"
    page.has_css?("div#message_developer[style='display: none;']").should be_false
  end
end


Then /^I fill in "([^"]*)" for this task a message with "([^"]*)"$/ do |field, value|
  with_scope('div#messages_developer div.new') do
    click_link('New')
  end
  fill_in(field, :with => value)
end




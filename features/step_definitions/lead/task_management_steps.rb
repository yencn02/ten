Given /^I have the following projects:$/ do |table|
  table.hashes.each do |hash|
    company = Factory(:client_company, :name => hash[:client])
    client_group = Factory(:client_group, :name => "Group for " + hash[:client], :client_company => company)
    Factory(:project, :name => hash[:project], :client_group => client_group, :worker_group => @current_account.worker_groups[0], :status => "active")
  end
end

Then /^I should see the following projects:$/ do |table|
  table.hashes.each do |hash|
    page.should have_content(hash[:project])
  end
end

Then /^I should see the following tasks:$/ do |table|
  table.hashes.each do |hash|
    page.should have_content(hash[:title])
  end
end

When /^I click the text "([^"]*)" of the note$/ do |description|
  change = TechnicalNote.find_by_description(description)
  find("#note_description_#{change.id}_in_place_editor").click
end

When /^I change text "([^"]*)" to "([^"]*)"$/ do |old_value, new_value|
  change = TechnicalNote.find_by_description(old_value)
  page.evaluate_script("tinyMCE.editors.textarea_note_description_#{change.id}_in_place_editor.setContent('#{new_value}')")

end

When /^I change note "([^"]*)" to "([^"]*)"$/ do |old_value, new_value|
  change = AttachedFile.find_by_description(old_value)
  page.evaluate_script("tinyMCE.editors.textarea_file_description_#{change.id}_in_place_editor.setContent('#{new_value}')")
end


Given /^I have the project "([^\"]*)" with the client "([^\"]*)"$/ do |project, client|
    company = Factory(:client_company, :name => client)
    client_group = Factory(:client_group, :name => "Group for " + client, :client_company => company)
    @project = Factory(:project, :name => project, :client_group => client_group, :worker_group => @current_account.worker_groups[0])
    milestone = Factory.create(:milestone, :project => @project)
end

Given /^the project "([^\"]*)" includes the following tasks:$/ do |project, table|
  project = Project.find_by_name(project)
  milestone = Factory.create(:milestone, :project => project)
  table.hashes.each do |hash|
      client_request = Factory.create(:client_request, :title => hash[:title], :milestone => milestone)
      worker = (hash[:status] != Task::UNASSIGNED)? @current_account : nil
      task = Factory(:task, :project => project,
        :title => hash[:title],
        :client_request => client_request,
        :worker => worker,
        :status => hash[:status])
  end
end

Given /^I am a member of the project "([^\"]*)"$/ do |project|
    @project = Factory(:project, :name => project, :worker_group => @current_account.worker_groups[0])
end

Given /^the project "([^\"]*)" includes the following client requests:$/ do |project, table|
  project = Project.find_by_name(project)  
  table.hashes.each do |hash|    
      milestone = Milestone.find_by_title(hash[:milestone])
      if(milestone.nil?) then
        milestone = Factory.create(:milestone, :title =>hash[:milestone],:project => project)
      end      
      client_request = Factory.create(:client_request,
                        :title => hash[:title],
                        :status => hash[:status],
                        :created_at => DateTime.strptime(hash[:created_at],"%m/%d/%Y"),
                        :priority => ClientRequest.priority_value_for(hash[:priority]),
                        :description => hash[:description],
                        :milestone => milestone)
  end
end

Given /^the client request "([^\"]*)" includes the following tasks:$/ do |request, table|
  client_request = ClientRequest.find_by_title(request)
  table.hashes.each do |hash|
    worker = Worker.find_by_login(hash[:worker])
    if(worker.nil?)
      worker = Factory(:worker, :login => hash[:worker], :name => hash[:worker],:worker_groups => @current_account.worker_groups)
    end
   
    task = Factory(:task, :project => client_request.milestone.project,
      :title => hash[:title],
      :client_request => client_request,
      :worker => worker,
      :estimated_hours => hash[:estimated],
      :status => "assigned",
      :due_date => DateTime.strptime(hash[:due_date],"%m/%d/%Y"))    
  end
end

Given /^the project "([^\"]*)" includes the following workers:$/ do |project, table|
  project = Project.find_by_name(project)
  table.hashes.each do |hash|
      Factory(:worker, :login => hash[:login], :name => hash[:login], :email => hash[:login] + '@company.com',:worker_groups => @current_account.worker_groups)
  end
end

Given /^the client request "([^\"]*)" includes the following changes:$/ do |request, table|
  client_request = ClientRequest.find_by_title(request)
  table.hashes.each do |hash|
    Factory(:client_request_change,
      :client_request => client_request,
      :description => hash[:description],
      :created_at => DateTime.strptime(hash[:created_at],"%m/%d/%Y"))
  end
end

Then /^I should see the following changes:$/ do |table|  
  table.hashes.each do |hash|    
    page.should have_content(hash[:description])
    page.should have_content(Date.strptime(hash[:created_at],"%m/%d/%Y").strftime("%b/%d/%Y"))
  end
end


Given /^the task "([^\"]*)" includes the following technical notes:$/ do |title, table|
  task = Task.find_by_title(title)
  table.hashes.each do |hash|
    tech_note = TechnicalNote.create!(:description => hash[:description],
          :created_at => DateTime.strptime(hash[:created_at],"%m/%d/%Y"),
          :task => task)
  end
end

Then /^I should see the following technical notes:$/ do |table|  
  table.hashes.each do |hash|    
    page.should have_content(hash[:description])
  end
end

Given /^the task "([^\"]*)" includes the following files:$/ do |title, table|
  task = Task.find_by_title(title)
  table.hashes.each do |hash|
    af = AttachedFile.new
    af.description = hash[:description]
    af.file_file_name = hash[:filename]
    af.file_file_size = hash[:size].to_i
    af.file_content_type = hash[:content_type]
    af.created_at = DateTime.strptime(hash[:created_at],"%m/%d/%Y")
    af.task = task
    af.save!
  end
end

Then /^I should see the following files:$/ do |table|
  table.hashes.each do |hash|
     page.should have_content(hash[:filename])
     page.should have_content(hash[:description])
  end
end

Given /^the client request "([^\"]*)" includes the following unassigned tasks:$/ do |request, table|
  client_request = ClientRequest.find_by_title(request)
  table.hashes.each do |hash|
    task = Factory(:task, :project => client_request.milestone.project,
      :title => hash[:title],
      :client_request => client_request,
      :status => "open",
      :start_date => nil,
      :due_date => nil)
  end
end

When /^I follow "([^\"]*)" on "([^\"]*)" task$/ do |link, title|
  task = Task.find_by_title(title)
  within "tr#task#{task.id}" do
    click_link link
  end
end

When /^I attach the file at "([^\"]*)" to "([^\"]*)" on "([^\"]*)" panel$/ do |path, field, panel|
  panel_div = "div#" + panel
  path= "#{Rails.root + path}"  
  within panel_div do
    attach_file(field, path)
  end
end

When /^I follow "Delete" to remove "([^\"]*)" on "files__task" panel$/ do |filename|
  file = AttachedFile.find_by_file_file_name(filename)
  visit "attached_files/delete/#{file.id}?afp=1&idSuffix=__task"
end

When /^I follow "Delete" to remove "([^\"]*)" on "notes" panel$/ do |description|
  note = TechnicalNote.find_by_description(description)
  visit "tasks/delete_note/#{note.id}"
end

When /^I click on "([^\"]*)" on Notes panel$/ do |text|
  @note = TechnicalNote.find_by_description(text)
  selenium.fire_event "noteDescription#{@note.id}", :click
end

When /^I click on "([^"]*)" on "([^"]*)" panel$/ do |description, panel|
  file = AttachedFile.find_by_description(description)
  find("#file_description_#{file.id}_in_place_editor").click
end


When /^I fill in "([^\"]*)" with "([^\"]*)" on Notes panel$/ do |f, text|
  selenium.type "xpath=//form[@id='noteDescription#{@note.id}-inplaceeditor']/textarea[1]", text
end

When /^I fill in "([^\"]*)" with "([^\"]*)" on Task File panel$/ do |f, text|
  selenium.type "xpath=//form[@id='fileDescription#{@file.id}-inplaceeditor']/textarea[1]", text
  #fill_in f, :with => text
end

When /^I press "([^\"]*)" on "([^\"]*)" panel$/ do |button, panel|
  panel_div = "div#" + panel
  within panel_div do
    click_button button
  end

end

When /^I follow "([^\"]*)" on "([^\"]*)" panel$/ do |link, panel|
  panel_div = "div#" + panel
  with_scope(panel_div) do
    click_link(link)
  end  
end

When /^I fill in note with "([^"]*)" for "([^"]*)" on "([^"]*)" panel$/ do |value, task, panel|
  panel_div = "div #"+ panel
  with_scope(panel_div) do
    suffix = task
    page.evaluate_script("tinyMCE.editors.fileNote__#{suffix}.setContent('#{value}')")
  end
end






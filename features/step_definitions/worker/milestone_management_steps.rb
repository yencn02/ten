Given /^the complete project has "([^\"]*)" milestones that are a range of "([^\"]*)", "([^\"]*)", and "([^\"]*)"$/ do |count, status1, status2, status3|
  @far_milestone = Factory.create(:far_milestone, :project => @project)
  @near_milestone = Factory.create(:near_milestone, :project => @project)
  @due_milestone = Factory.create(:late_milestone, :project => @project)
end

Given /^the complete project "([^\"]*)" tasks \(reqs\) associated with each milestone$/ do |count|
	i = 0
  @project.milestones.each do |ms|
		i = i +1
	  req = Factory.create(:client_request, :milestone => ms,:title => "Req for milestone #{i.to_s}")
	  task = Factory.create(:task, :title =>"Task for req '#{req.title}'",
			:project => @project,
			:client_request => req,
			:worker => @worker)
	end
end

Then /^I should see the current date bar$/ do
  response.should have_selector("li#current_date")
end

Then /^I should see the milestones sorted by date, due first at the top, due last at the bottom$/ do
  milestones = Milestone.milestone_by_due_date(@project.id)
	 k = 1
  showToday = true
	 milestones.each do |ms| 
			 if( ms.due_date > Date.today and showToday )
			  	k = k + 1
				 	showToday = false
			 end
		  response.should have_selector("#milestones li:nth-child(#{k.to_s}) div.due_date", :content => ms.due_date.strftime("%d %b").upcase)
		  k = k + 1
  end
end

Then /^I should see a milestone that is (\w+) (\w+) the current date bar with a date color of (\w+)$/ do |status, placement, color|
 conditions = "project_id = " + @project.id.to_s
	if(status == "NEAR") 
 conditions += " AND due_date > '#{Date.today}' AND due_date < '#{Date.today + $near_milestone.day}'"
 elsif (status == "FAR")
  conditions += " AND due_date > '#{Date.today + $near_milestone.day}'" 	
	else # late
		 conditions += " AND due_date < '#{Date.today}'"		
	end
 ms = Milestone.find(:first, :conditions => conditions)
 
 response.should have_selector("#milestones li.#{placement}") do |li|
		li.should have_selector("div.#{color}", :content => ms.due_date.strftime("%d %b").upcase)
 end
end



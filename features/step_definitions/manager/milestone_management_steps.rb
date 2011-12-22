Then /^I should see "([^\"]*)" on the menu bar$/ do |project|
  And "I should see \"#{project}\""
end

When /^the project "([^\"]*)" includes the following milestones$/ do |name, table|
  project = Project.find_by_name(name)
  table.hashes.each do |hash|
    Factory(:milestone, :title => hash[:title], :project => project, :due_date => "2009-08-31")
  end
end

Then /^I should see the following date$/ do |table|
  table.hashes.each do |hash|
    And "I should see \"#{hash[:title]}\""
  end
end

Then /^I should see the following project:$/ do |table|
  table.hashes.each do |hash|
    And "I should see \"#{hash[:project]}\""
  end
end
Then /^Then I should see the following:$/ do |table|
  table.hashes.each do |hash|
    And "I should see \"#{hash[:title]}\""
  end
end
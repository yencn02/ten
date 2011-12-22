Then /^I should see the "([^\"]*)" menu item$/ do |text|
  Then "I should see \"#{text}\""
end

Then /^I should not see the "([^\"]*)" menu item$/ do |text|
  Then "I should see \"#{text}\""
end

Then /^I should see the following menu items$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:name]}\""
  end
end


Then /^I should not see the following menu items$/ do |table|
  table.hashes.each do |hash|
    Then "I should not see \"#{hash[:name]}\""
  end
end
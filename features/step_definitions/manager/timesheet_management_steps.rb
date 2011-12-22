Then /^I should see the following project$/ do |table|
  table.hashes.each do |hash|     
    Then "I should see \"#{hash[:project]}\""
  end
end


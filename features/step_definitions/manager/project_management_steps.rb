Given /^I have the following projects$/ do |table|
  table.hashes.each do |hash| 
    group = Factory(:client_group, :name => hash[:client])
    Factory(:project,
      :name         => hash[:name],
      :description  => hash [:description],
      :status       => hash [:status],
      :client_group => group,
      :worker_group => @current_account.worker_groups.first)
  end
end

Then /^I should see the following projects$/ do |table|
  table.hashes.each do |hash|
    Then "I should see \"#{hash[:name]}\""
    Then "I should see \"#{hash[:client]}\""
    Then "I should see \"#{hash[:status]}\""
    Then "I should see \"#{hash[:description]}\""
  end
end

Given /^I am a member of the following worker groups$/ do |table|
  table.hashes.each do |hash|
    group = Factory(:worker_group, :name => hash[:name])
    @current_account.worker_groups << group
  end
end
Given /^we have following clients$/ do |table|
  table.hashes.each do |hash|
    Factory(:client_group, :name => hash[:name])    
  end
end

Then /^I wait for response about "([^"]*)" seconds$/ do |number|
  sleep number.to_i
end
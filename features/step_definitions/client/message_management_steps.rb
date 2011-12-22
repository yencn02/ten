Given /^I have the following client messages$/ do |table| 
  table.hashes.each do |hash|    
    status = hash[:status].downcase
    if hash[:sender].eql?('me')   
      sender = @client
    else
      sender = Account.find_by_login(hash[:sender])
      sender = Factory(:client, :client_groups => @client.client_groups, 
        :login => hash[:sender], :name => hash[:sender]) if sender.nil?   
    end 
    project = Project.find_by_name(hash[:project])
    project = Factory(:project, :client_group => sender.client_groups[0], 
      :name => hash[:project]) if project.nil?  
    client_request = ClientRequest.find_all_by_title(hash[:request]).first
    client_request = Factory(:client_request, 
      :milestone => Factory(:milestone, :project => project), :title => hash[:request]) if client_request.nil?  
 
    message = Factory(:client_message, :title => hash[:message], :body => hash[:message], 
      :sender => sender, :client_request => client_request)
    ClientMessage.init_message_status(message, status)    
  end
end

Then /^I should see the following client messages$/ do |table|  
  table.hashes.each do |hash|   
    status = hash[:status].downcase
    Then "I should see \"#{hash[:project]}\""
    Then "I should see \"#{@client.name}\""  if hash[:sender].eql?('me')
    Then "I should see \"#{status}\""    
  end
end

Then /^the following client messages should not be shown in bold$/ do |table|
  table.hashes.each do |hash| 
    status = hash[:status].downcase
    Then "I should see \"#{hash[:project]}\""
    page.should_not have_css("unread_status")    
    Then "I should see \"#{@client.name}\"" if hash[:sender].eql?('me')
    Then "I should see \"#{status}\""    
  end
end

Then /^I should not see the following client messages$/ do |table|
  table.hashes.each do |hash|
    page.should_not contain(:content => hash[:message])   
  end
end

Then /^the following client messages should be shown in bold$/ do |table|
  table.hashes.each do |hash| 
    status = hash[:status].downcase
    Then "I should see \"#{hash[:project]}\""    
    Then "I should see \"#{@client.name}\""  if hash[:sender].eql?('me')
    Then "I should see \"#{status}\""    
  end
end
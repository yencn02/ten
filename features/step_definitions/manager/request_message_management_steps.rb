Given /^the client request "([^\"]*)" includes the following messages:$/ do |request, table|
  client_request = ClientRequest.find_by_title(request)
  table.hashes.each do |hash|
    sender = Client.find_by_login(hash[:sender])
    if(sender.nil?) 
      sender = Factory(:client,
        :login => hash[:sender],
        :name => hash[:sender],
        :client_groups => [client_request.milestone.project.client_group])
    end
    message = Factory(:client_message,
      :sender => sender,
      :body => hash[:body],
      :created_at => DateTime.strptime(hash[:sent_at], "%m/%d/%Y"),
      :client_request => client_request)
    ClientMessage.init_message_status(message)
  end
end

Then /^I should see the following client request messages:$/ do |table|
  table.hashes.each do |hash|
    page.should have_content(hash[:sender])
    page.should have_content(hash[:body])
  end
end

Given /^the client request "([^\"]*)" include the message$/ do |request, msg|
  client_request = ClientRequest.find_by_title(request)
  Factory(:client_message,
    :sender => @current_account,
    :body => msg,
    :client_request => client_request)  
end

When /^I click on "([^\"]*)" to view full message$/ do |msg_summary|
  msg_summary = "%#{msg_summary}%"
  msg = ClientMessage.find(:first, :conditions => ["body like ?", msg_summary])
  find("#newclient#{msg.id} .header").click
end

Then /^I should see$/ do |string|
  string.each_line do |line|
    page.should have_content(line.chomp)    
  end
end

Given /^no messages have been posted discussing the client request "([^\"]*)"$/ do |request|
  client_request = ClientRequest.find_by_title(request)
  ClientMessage.delete_all(["client_request_id = ?", client_request.id])
end

When /^I fill in "([^\"]*)" on reply form with "([^\"]*)"$/ do |textfield, value|
  page.evaluate_script("tinyMCE.editors.client_message_body.setContent('#{value}')")
end

When /^I fill in "([^\"]*)" on new message form with$/ do |textfield, string|
  within("div#newMessage__client") do
    fill_in textfield, :with => string
  end
end

When /^I follow "([^"]*)" to remove the message$/ do |arg1|
  page.evaluate_script('window.confirm = function() { return true; }')
  Then "I follow \"delete\""
end

When /^I click on "([^\"]*)"$/ do |msg_summary|
  # this is javascript action
  msg_summary = "%#{msg_summary}%"
  @msg = ClientMessage.find(:first, :conditions => ["body like ?", msg_summary])  
  #set hidden field
  set_hidden_field("clientRequestIdReply__client", @msg.id)
end

Given /^To discuss the client request "([^\"]*)" I posted the message$/ do |request, string|
  client_request = ClientRequest.find_by_title(request)
  Factory(:client_message,
    :sender => @current_account,
    :body => string,
    :client_request => client_request)    
end

When /^I follow "Delete" to remove the message$/ do
  visit "messages/delete_client_message/#{@msg.id}"
end

When /^I click a link "([^"]*)"$/ do |msg|
  click_link "client-discussion-link"
end


When /^I fill in Content on new message form$/ do |content|  
   page.evaluate_script("tinyMCE.editors.client_message_body.setContent('#{content}')")
end
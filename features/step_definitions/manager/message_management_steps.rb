Given /^I have a message with a title of (.+)$/ do |title|
  project = Factory(:project,:worker_group => @current_account.worker_groups[0])
  client = Factory(:client, :client_groups => [project.client_group])
  client_request = Factory(:client_request, 
      :milestone => Factory(:milestone,:project => project), 
      :client => client)
  worker = Factory(:worker, :worker_groups => @current_account.worker_groups)
  task = Factory(:task, :client_request => client_request, :worker => worker, :project => project)
  message = Factory(:message, :title => title, :body => title, :sender => worker, :task => task)
  Message.init_message_status(message)
end


Given /^I have the following messages$/ do |table|
  project = Factory(:project,:worker_group => @current_account.worker_groups[0])
  client = Factory(:client, :client_groups => [project.client_group])
  client_request = Factory(:client_request, 
      :milestone => Factory(:milestone,:project => project), 
      :client => client)
  task = Factory(:task, :client_request => client_request, :worker => @current_account, :project => project)
  table.hashes.each do |hash|
    message = Factory(:message, :title => hash[:title], :body => hash[:title], :sender => @current_account, :task => task) 
    Message.init_message_status(message, hash[:status])
  end
end

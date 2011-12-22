module Client::MessagesHelper
  
  def status_message(message, current_account)
    prefix =  "message"
    project = ""
    if message.is_a? Message then
      project = message.task.project.name
    else
      project = message.client_request.milestone.project.name
      prefix = "client_message"
    end    
    return prefix, project, message.status_for(current_account)+ "_status"
  end
  
end

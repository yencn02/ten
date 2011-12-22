module MessagesHelper
  def message_status(message, current_account)     
    prefix =  "message"
    project = ""
    if message.is_a? Message then
      project = message.task.project.name
    else
      project = message.client_request.milestone.project.name
      prefix = "client_message"
    end
    msg_statuses = message.status_for(current_account)
    return project, prefix, "#{msg_statuses}" 
  end
  
  
  
end

require "logging"

class Mailer < ActionMailer::Base
  default :from => "no-reply@endax.com"

  def client_request_message(message)
    emails = message.client_request.milestone.project.clients.map(&:email)    
    subject_line = "[#{message.client_request.milestone.project.name}]"
    subject_line << "[ClientRequest Discussion]"
    subject_line << "#{message.client_request.title}"    
    @message = message    
    mail(:to => emails, :subject => subject_line)

  end


  def send_message_to_manager(message)
    manager = message.client_request.milestone.project.manager    
    email = manager.email
    @manager_name = manager.name
    subject_line = "[#{message.client_request.milestone.project.name}]"
    subject_line << "[ClientRequest Discussion]"
    subject_line << "#{message.client_request.title}"
    @message = message
    mail(:to => email, :subject => subject_line)

  end

  def task_message(message)
    emails = message.task.project.workers.map(&:email)
    emails.delete_if {|x| x.eql?(message.sender.email)}
    subject_line = "[#{message.task.project.name}]"
    subject_line << "[Task Discussion]"
    subject_line << "#{message.task.title}"    
    @message = message
    mail(:to => emails, :subject => subject_line)
  end

  def task_assigned(task)
    email = task.worker.email
    subject_line = "[Assignment]"
    subject_line << "[#{task.project.name}]"
    subject_line << "#{task.title}"
    @task = task
    mail(:to => email, :subject => subject_line)
  end

end

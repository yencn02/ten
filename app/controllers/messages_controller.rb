class MessagesController < ApplicationController
  #layout "temp"
  before_filter :login_required

  def index
    @messages = current_account.top_messages
    @messages = @messages + current_account.top_client_messages
    @messages.sort!{|a,b| b.created_at <=> a.created_at }    
  end
  
  def list    
    status = params[:status]    
    case status
    when MessageStatus::READ
      @messages = current_account.read_messages + current_account.read_client_messages      
    when  MessageStatus::UNREAD
      @messages = current_account.unread_messages + current_account.unread_client_messages      
    when MessageStatus::ARCHIVED
      @messages = current_account.archived_messages + current_account.archived_client_messages    
    else
      @messages = current_account.top_messages + current_account.top_client_messages      
    end
    @messages.sort!{|a,b| b.created_at <=> a.created_at }    
    render :index
  end
	
  def show    
    @message = Message.find(params[:id])
		if(@message.status == "unread") then
		  @message.set_status(current_account.id, MessageStatus::READ)
		  @message.save
	  end
		redirect_to edit_task_path(@message.task)
  end
  
  def read_message
    id = params[:id]
    type = params[:type]
    account = current_account
    if(type == "message") then
      message = Message.find(id)
      Message.set_status(account.id, id, MessageStatus::READ)
      redirect_to task_path(message.task)
    else
      client_message = ClientMessage.find(id)
      ClientMessage.set_status(account.id, id, ClientMessageStatus::READ)
      redirect_to task_path(client_message.client_request.task)
    end
  end

  def update_status    
    status  = params[:read] || params[:unread] || params[:archive]
    message_ids = params[:message_ids]
    client_message_ids = params[:client_message_ids]
    account = current_account
    Message.set_status(account.id, message_ids, status) unless message_ids.nil?
    ClientMessage.set_status(account.id, client_message_ids, status)  unless client_message_ids.nil?
    redirect_to list_messages_path
  end
  
end

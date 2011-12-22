class Client::MessagesController < ApplicationController
  #layout "temp"
  before_filter :login_required
  require_role Role::CLIENT
  def index 
    list
    render :action => :list
  end
  
  def list    
    status = params[:status]     
    flash[:information] = "List of #{status} messages"
    case status
    when MessageStatus::READ
      @messages =  current_account.read_client_messages
    when  MessageStatus::UNREAD
      @messages =  current_account.unread_client_messages      
    when MessageStatus::ARCHIVED
      @messages =  current_account.archived_client_messages      
    else
      @messages = current_account.all_client_messages
    end
    @messages.sort!{|a,b| b.created_at <=> a.created_at } 
  end
  
  def read_message
    id = params[:id]        
    client_message = ClientMessage.find_by_id(id)
    ClientMessage.set_status(current_account.id, id, ClientMessageStatus::READ)
    redirect_to client_request_path(client_message.client_request)    
  end
    
  def update_status    
    status  = params[:read] || params[:unread] || params[:archive]
    client_message_ids = params[:client_message_ids]           
    number_update = ClientMessage.set_status(current_account.id, client_message_ids, status)  unless client_message_ids.nil?
    if (number_update.to_i > 0)
      if status.eql?('archived')
        flash[:info] = "The selected messages have been archived"
      else    
        flash[:info] = "The selected messages have been updated status"
      end
    else
      flash[:notice] = "The selected messages haven't been updated status"  
    end
    redirect_to list_client_messages_path
  end
  
end

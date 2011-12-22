class ClientMessage < ActiveRecord::Base
  belongs_to :client_request
  belongs_to :sender, :class_name => "Account", :foreign_key => "sender_id"
  belongs_to :original_message, :class_name => "ClientMessage", :foreign_key => "reply_to"
  has_many :client_message_statuses, :dependent => :delete_all
  validates :body, :presence => true
  validates :sender, :presence => true  
  scope :by_client_request,
    lambda {|id| {:conditions => ["client_request_id = ?", id], :order => "created_at ASC"}}  
  

  
  class << self

    # initialize status for message in a group
    def init_message_status(message, status = ClientMessageStatus::UNREAD)
      #insert status for worker group      
       accounts =  message.client_request.milestone.project.client_group.accounts    
       accounts = accounts  + message.client_request.milestone.project.worker_group.accounts       
       accounts.each do |account|
         ClientMessageStatus.create(:client_message => message, :account => account, :status => status)
       end
    end
    
    # set status for all messages of a user
    def set_status(account_id, message_ids, status)
      ClientMessageStatus.update_all("status='#{status.downcase}'", :account_id => account_id, :client_message_id => message_ids)
      
    end  
    
    def client_discussion_on_task(client_request_id, page, per_page = 3)
      result = self.joins(:sender).order("created_at DESC").page(page).per(per_page).where(:client_request_id => client_request_id)
      puts result
      return result
    end
    
  end

  def status_for(account) 
    return self.client_message_statuses.status_for(account).first.status
  end
   
end

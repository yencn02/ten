class Message < ActiveRecord::Base

  # Message contents are word-wrapped if they're longer than LINE_WIDTH width
  LINE_WIDTH = 60
  STATUSES = [:read, :unread, :archived]
  
  belongs_to :sender, :class_name => "Worker", :foreign_key => "sender_id"
  belongs_to :original_message, :class_name => "Message", :foreign_key => "reply_to"
  belongs_to :task
  has_many :message_statuses, :dependent => :delete_all
  validates :sender, :presence => true
  validates :body, :presence => true
  #validates_length_of :title, :within => 1..255, :allow_nil => true
	
  class << self
    # Get messages posted by workers on a task
    def developer_discussion_on_task(task_id, page, per_page = 3)      
      result = self.joins(:sender).order("created_at DESC").page(page).per(per_page).where("accounts.type = ? and task_id =?", "Worker", task_id)
      puts result
      return result
    end
	
    # Count the number of recently posted messages which relates to the specified project.
    def recent_count(project)
      # Count task messages
      task_message_count = 0
      project.tasks.each do |task|
        task_message_count += self.count(:conditions =>
          ["task_id = ? AND updated_at > ?", task.id, $duration_for_activity_calculation.day.ago])
      end
      return task_message_count
    end
    
    def init_message_status(message, status = MessageStatus::UNREAD)
      message.sender.worker_ids.each do |worker|
        MessageStatus.create(:message => message, :account_id => worker, :status => status)
      end
    end
    
    def set_status(account_id, message_ids, status)            
      MessageStatus.update_all("status='#{status.downcase}'", :account_id => account_id, :message_id => message_ids)
    end
  end
  
  def status_for(account) 
    return self.message_statuses.status_for(account).first.status
  end
end

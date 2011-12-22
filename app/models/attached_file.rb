class AttachedFile < ActiveRecord::Base
  # Model relationship 
  belongs_to :milestone
  belongs_to :client_request
  belongs_to :task

  # Attachment configuration
  # TODO Externalize the maximum upload file size
  #has_attachment :storage => :file_system#, :max_size => 20.megabytes
  validates_attachment_size :file, :less_than => 5.megabyte, :message => "must be less than or equal 5 megabyte"
  has_attached_file :file, :path => ":rails_root/public/system/:attachment/:id/:style_:basename.:extension",
    :url => "/system/:attachment/:id/:style_:basename.:extension"

  #validates :file_fil_name, :presence => true
  validates_attachment_presence :file


  # Class methods
  class << self
    # Get client_request files on the specified page.
    def paginate_by_client_request(client_request_id, page)
      att_file = AttachedFile.order("created_at DESC").page(page).per(3).where("client_request_id =?", client_request_id)
      puts att_file
      att_file
    end

    # Get task files on the specified page.
    def paginate_by_task(task_id, page)
      att_file = AttachedFile.order("created_at DESC").page(page).per(3).where("task_id =?", task_id)
      puts att_file
      att_file
    end
    
    # Delete an attached file of a client_request. If the specified account is not allowed to delete
    # the file, a SecurityError will be raised.
    def delete_client_request_file(id, account)
      file = AttachedFile.find(id)
      client_request = ClientRequest.find(file.client_request_id)
      if client_request.allows_update?(account)
        AttachedFile.delete(id)
      else
        raise SecurityError,
          "#<Account id:#{id}> is not allowed to delete #<AttachedFile id:#{id}>."
      end
    end
  end
end

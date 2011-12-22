class ClientRequestChange < ActiveRecord::Base
  belongs_to :client_request
  validates_presence_of :description
  validates_presence_of :client_request

  class << self
    def paginate_by_client_request(client_request_id, page, per_page = 3)
      self.paginate :page => page, :per_page => per_page,
        :conditions => ["client_request_id = ?", client_request_id], :order => 'created_at DESC'
    end
    
    # Find a client_request change by id.
    # If the specified account is not allowed to access the specified client_request change, a
    # SecurityError will be thrown.
    def find_by_id_with_security_check(id, account)
      if account.nil?
        raise ArgumentError, "account must not be nil."
      end
      change = self.find_by_id(id)
      return change if change.nil?
      unless change.allows_view?(account)
        raise SecurityError,
          "#<Account id:#{account.id}> is not allowed to view #<ClientRequestChange id:#{id}>."
      end
      return change
    end
  end

  # Check if the specified account is allowed to view this client_request change.
  def allows_view?(account)    
#    self.client_request.milestone.project.client_group.accounts.include?(account)
    return true
  end
end

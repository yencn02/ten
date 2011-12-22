require "aasm"

class ClientRequest < ActiveRecord::Base
  include AASM
  
  NEW = "new"
  STARTED = "started"
  MET = "met"
  UNMET = "unmet"
  ARCHIVED = "archived"
  
  EXTREME = "Extreme"
  HIGH = "High"
  MEDIUM = "Medium"
  LOW = "Low"
  
  PRIORITIES = ['Extreme', 'High', 'Medium', 'Low']
  STATUS = ['select state','Unmet', "Archived", "Invalid"]


  
  belongs_to :milestone
  belongs_to :client
  has_many :attached_files, :dependent => :delete_all
  has_many :client_messages, :order => 'created_at DESC'
  has_many :client_request_assignments
  has_many :client_request_changes
  has_one :task

  has_many :top_client_messages, :class_name => 'ClientMessage', :order => 'created_at DESC', :limit => 1

  aasm_column :status
  aasm_initial_state :new
  aasm_state :new
  aasm_state :started
  aasm_state :met
  aasm_state :unmet
  aasm_state :archived
  aasm_state :invalid
  
  aasm_event :start do
    transitions :to => :started, :from => [:new]
  end

  aasm_event :review do
    transitions :to => :met, :from => [:started]    
  end

  aasm_event :reopen do
    transitions :to => :started, :from => [:met]
  end

  aasm_event :archive do
    transitions :to => :archived, :from => [:met]    
  end

  aasm_event :invalid do
    transitions :to => :invalid, :from => [:new, :started, :met, :unmet, :archived ]
  end


  validates :title, :presence => true
  validates_length_of :title, :within => 1..255
  validates :description, :presence => true
  validates :priority, :presence => true
  validates :milestone, :presence => true

  class << self    
    # Count the number of client_requests created or updated recently.
    def recent_count(milestones)
      client_request_count = 0
      milestones.each do |milestone|
        client_request_count += self.count(:conditions =>
          ["milestone_id = ? AND updated_at > ?",
          milestone.id, $duration_for_activity_calculation.day.ago])
      end
      return client_request_count
    end
    
    def get_priority_list
      priority_list = []
      i = 1
      ClientRequest::PRIORITIES.each do |p|
        priority_list.push([p, i])
        i = i+1
      end
      return priority_list
    end
    
    def priority_value_for(priority)
      return ClientRequest::PRIORITIES.index(priority) + 1
    end
    
    def priority_text_for(priority)
      return ClientRequest::PRIORITIES[priority -1]
    end

    def paginate_requests(project_ids, priority, page, per_page)
      unless priority == "all"
        joins(:milestone).paginate(
          :conditions => {"milestones.project_id" => project_ids, :priority => priority_value_for(priority)},
          :page => page, :per_page => per_page, :order => "created_at DESC")
      else
        joins(:milestone).paginate(
          :conditions => {"milestones.project_id" => project_ids},
          :page => page, :per_page => per_page, :order => "created_at DESC")
      end
    end
  end

  def total_billed_hours
    return task.total_billed_hours
  end

  def total_estimated_hours
    return task.estimated_hours
  end

  def allows_update?(account)

    if(account.is_a?(Client)) then
      return self.milestone.project.allows_access?(account)
    else
      # Administrators are allowed by default
      return true if account.has_role?(Role::ADMIN)
      wk_list = self.worker_list
      return false if wk_list.empty?
    # Only allow corresponding leaders to update a client_request
      return (wk_list.include?(account) && account.has_role?(Role::LEAD))
    end
  end

  # Check if a worker has the right to access this client_request. Workers with "admin" role are
  # automatically authorized.
  def has_right?(worker_id)
    worker = Worker.find(worker_id)
    if worker.has_role?(Role::ADMIN)
      return true
    end
    worker_list = self.worker_list
    if worker_list.empty?
      return false
    end
    worker_list.include?(worker)
  end

  # Get a list of workers who have the right to access this client_request.
  def worker_list
    self.milestone.project.worker_group.accounts
  end

  def show_client_request_path
    return "/client/requests/#{self.id}/project/#{self.milestone.project_id}/#{ClientRequest::priority_text_for(self.priority)}"
  end

end

require "aasm" unless defined?(AASM)
class Task < ActiveRecord::Base
	include AASM
  validate :validate_data, :on => :update
  
  PER_PAGE = 10
  ALL = "all"
  UNASSIGNED = "unassigned"
  ASSIGNED = "assigned"
  COMPLETED = "completed"
  VERIFIED = "verified"
  
  
  belongs_to :project
  belongs_to :client_request
  belongs_to :worker
  has_many :attached_files, :dependent => :delete_all
  has_many :billable_time, :dependent => :delete_all
  has_many :technical_notes, :dependent => :delete_all
  has_many :messages, :dependent => :delete_all

  aasm_column :status
  aasm_initial_state :unassigned
  aasm_state :unassigned
  aasm_state :assigned
  aasm_state :completed
  aasm_state :archived
  aasm_state :invalid

  aasm_event :assign do
    transitions :to => :assigned, :from => [:unassigned]
  end

  aasm_event :complete do
    transitions :to => :completed, :from => [:assigned]
  end

  aasm_event :archive do
    transitions :to => :archived, :from => [:completed]
  end

  aasm_event :reopen do
    transitions :to => :assigned, :from => [:completed]
  end

  aasm_event :invalid do
    transitions :to => :invalid, :from => [:unassigned, :assigned, :completed, :archived]
  end

  # Attribute validation
  validates :title, :presence => true
  validates_length_of :title, :within => 3..255
  validates :project, :presence => true
  validates :client_request, :presence => true

  class << self    
    # Return a worker's tasks with the specified status.
    def worker_task_list(worker_id, status)      
      where(:worker_id => worker_id, :status => status)
    end

    # Return states which are visible on the menu bar.
    def visible_task_statuses
      return ["all", "unassigned", "assigned", "completed", "archived", "verified"]
    end

    # Return the number of tasks created or updated recently.
    def recent_count(project_id)
      return Task.count(:conditions =>
        ["project_id = ? AND status <> ? AND updated_at > ?",
        project_id, :archived.id2name, $duration_for_activity_calculation.day.ago])
    end

    #
    # Find a user's tasks by status in the specified project.
    # If project_id is nil, find a user's tasks by status in all projects.
    #
    def find_by_status(status, project_id, account)
      raise SecurityError if account.nil?
      raise ActiveRecord::RecordNotFound unless self.visible_task_statuses.include?(status)
      conditions = Hash.new
      conditions[:status] = status if status != "all"
      if project_id.nil?
        projects = Project.find_by_account(account)
        project_ids = projects.collect {|project| project.id}
        conditions[:project_id] = project_ids
      elsif project_id != "all"
        project = Project.find_by_id(project_id, account)
        raise ActiveRecord::RecordNotFound if project.nil?
        conditions[:project_id] = project.id
      end      
      return self.all(:conditions => conditions, :order => "created_at DESC")
    end


    def find_task_other(status, project_id, account)
      raise SecurityError if account.nil?
      raise ActiveRecord::RecordNotFound unless self.visible_task_statuses.include?(status)
      conditions = Hash.new
      conditions[:status] = status if status != "all"
      if project_id.nil?
        projects = Project.find_by_account(account)
        project_ids = projects.collect {|project| project.id}
        conditions[:project_id] = project_ids
      elsif project_id != "all"
        project = Project.find_by_id(project_id, account)        
        raise ActiveRecord::RecordNotFound if project.nil?
        project_ids = project.id
      end      
      return self.all(:conditions => ["project_id in (?) and status <> ? and worker_id <> ?", project_ids, "open", account.id])
    end


    def find_task_other_by_status(status, project_id, account)
      raise SecurityError if account.nil?
      raise ActiveRecord::RecordNotFound unless self.visible_task_statuses.include?(status)
      conditions = Hash.new
      conditions[:status] = status if status != "all"
      if project_id.nil?
        projects = Project.find_by_account(account)
        project_ids = projects.collect {|project| project.id}
        conditions[:project_id] = project_ids
      elsif project_id != "all"
        project = Project.find_by_id(project_id, account)
        raise ActiveRecord::RecordNotFound if project.nil?
        project_ids = project.id
      end
      return self.all(:conditions => ["project_id in (?) and status = ? and worker_id <> ?", project_ids, status, account.id])
    end

    #
    # Find a user's tasks by status in the specified project.
    # If project_id is nil, find a user's tasks by status in all projects.
    #
    def paginate_by_status(status, project_id, page, account)
      raise SecurityError if account.nil?
      raise ActiveRecord::RecordNotFound unless self.visible_task_statuses.include?(status)
      conditions = Hash.new
      # If status equals to "all", status filter is not applied
      conditions[:status] = status if status != "all"      
      if project_id.nil?
        projects = Project.find_by_account(account)
        project_ids = projects.collect {|project| project.id}
        conditions[:project_id] = project_ids
      elsif project_id != "all"
        # Make sure the specified project exists
        project = Project.find_by_id(project_id, account)
        raise ActiveRecord::RecordNotFound if project.nil?
        conditions[:project_id] = project.id
      end
      return Task.paginate(:page => page, :per_page => PER_PAGE, :conditions => conditions, :order => "created_at DESC")
    end

    # Find a task by id, check if the specified account is allowed to access the specified task.
    # TODO Do not override find_by_id
    def find_by_id(task_id, account)
      if account.nil?
        raise ArgumentError, "account must not be nil."
      end
      task = Task.find(task_id)
      unless task.allows_view?(account)
        raise SecurityError,
          "#<Account id:#{account.id}> is not allowed to access #<Task id:#{task.id}>."
      end
      return task
    end
  end

  # Check if the specified account is allowed to access this task.
  def allows_access?(account)
    if account.nil?
      raise ArgumentError, "account must not be nil."
    end

    if account.id == self.worker_id
      return true
    else
      return false
    end
  end

  # Check if the current account is allowed to update the task. the "update" action includes create,
  # update and delete.
  def allows_update?(account)
    raise(ArgumentError, "account must not be nil.") if account.nil?
    return true if account.has_role?(Role::ADMIN)
    has_authorized_role = account.has_role?(Role::MANAGER)
    has_authorized_role = account.has_role?(Role::LEAD) unless has_authorized_role
    return has_authorized_role unless has_authorized_role
    authorized_worker_group = self.project.worker_group
    return account.worker_groups.include?(authorized_worker_group) ? true : false
  end

  # Check if the specified account is allowed to view this task.
  def allows_view?(account)
    raise(ArgumentError, "account must not be nil.") if account.nil?
    allows_view = false
    if account.has_role?(Role::ADMIN) || account.worker_groups.include?(self.project.worker_group)
      allows_view = true
    end
    return allows_view
  end

  def total_billed_hours
    BillableTime.sum("billed_hour", :conditions => {:task_id => self.id})
  end
  
  def validate_data
    errors.add(:estimated_hours, "can't must be greater than 0.5") if  (estimated_hours.nil? or estimated_hours < 0.5)
    errors.add(:start_date, "should not be null") if (start_date.nil?)
    errors.add(:due_date, "should not be null") if (due_date.nil?)
    if not (start_date.nil? or due_date.nil?)
      errors.add(:start_date, "should be on or before #{due_date}") if (start_date > due_date)
      errors.add(:due_date, "should be on or after #{start_date}") if (start_date > due_date)
    end
  end
  
end

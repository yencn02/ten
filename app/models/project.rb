class Project < ActiveRecord::Base
  include AASM
   

  NUMBER_OF_TOP_ACTIVE_PROJECTS = 3

  ACTIVE = "active"
  INACTIVE = "inactive"

  belongs_to :client_group
  belongs_to :worker_group
  has_many :milestones, :dependent => :delete_all
  has_many :tasks, :dependent => :delete_all

  has_many :open_tasks, :class_name => "Task", :conditions => {:status => 'open'}
  has_many :estimated_tasks, :class_name => "Task", :conditions => {:status => 'estimated'}
  has_many :assigned_tasks, :class_name => "Task", :conditions => {:status => 'assigned'}
  has_many :complete_tasks, :class_name => "Task", :conditions => {:status => 'complete'}
  has_many :verified_tasks, :class_name => "Task", :conditions => {:status => 'verified'}

  validates :name, :presence => true
  validates_uniqueness_of :name
  validates_length_of :name, :within => 1..32
  validates :description, :presence => true  
  validates :client_group, :presence => true
  validates :worker_group, :presence => true
  validates :status, :presence => true

  aasm_column :status
  aasm_initial_state :inactive
  aasm_state :active
  aasm_state :inactive
  aasm_event :activate do
    transitions :to => :active, :from => [:inactive]
  end

  aasm_event :deactivate do
    transitions :to => :inactive, :from => [:active]
  end

  define_index do
    indexes :name, :description, :activity, :status
    indexes client_group.name, client_group.description
    indexes worker_group.name, worker_group.description
    set_property :delta => :delayed
    has created_at, updated_at
  end

  class << self
    #
    # Find a project by the specified identifier. Return nil if the project does not exist.
    # If the specified account is not allowed to access the project, a SecurityError exception will
    # be thrown.
    #    
    
    def find_by_id(id, account)
      project = Project.find(id)
      unless project.nil?
        raise SecurityError unless project.allows_access?(account)
      end
      return project
    end

    # Find all projects related to the specified account.
    # Order the projects by activity.
    def paginate_by_activity(account, status, page, per_page = $menu_number_of_projects)      
      # Return nil if the specified account is nil      
      return nil if account.nil?      
      case
      when account.is_a?(Worker)
        if account.has_role?(Role::ADMIN)          
          projects = self.paginate :page => page,
            :conditions => {:status => status}, :per_page => per_page, :order => "activity DESC"
        else          
          worker_group_ids = account.worker_groups.collect {|g| g.id}                    
          projects = self.paginate :page => page, :per_page => per_page,
            :conditions => {:worker_group_id => worker_group_ids, :status => status}, :order => "activity DESC"
        end
      when account.is_a?(Client)
        client_group_ids = account.client_groups.collect {|g| g.id}
        projects = self.paginate :page => page, :per_page => per_page,
          :conditions => {:client_group_id => client_group_ids, :status => status}, :order => "activity DESC"
      end
      return projects
    end

    # Find the most active project
    def most_active(account)
      return nil if account.nil?
      most_active = nil
      if account.is_a?(Worker) 
        if account.has_role?(Role::ADMIN)
          most_active = self.first(:order => "activity DESC")
        else         
          worker_group_ids = account.worker_groups.collect {|g| g.id}          
         most_active = self.first(
            :conditions => {:worker_group_id => worker_group_ids}, :order => "activity DESC")
        end
      else
       client_group_ids = account.client_groups.collect {|g| g.id}
       most_active = self.first(
          :conditions => {:client_group_id => client_group_ids}, :order => "activity DESC")
      end
      return most_active
    end

    # Find all the projects which the specified account is allowed to access.
    def find_by_account(account)
      raise SecurityError if account.nil?
      projects = []
      if(account.is_a? Worker)
        account.worker_groups.each do |group|  #TODO convert to this to a JOIN model to avoid N^2 hits to the db
          group.projects.each do |project|
            projects << project
          end
        end
      else
        account.client_groups.each do |group|  #TODO convert to this to a JOIN model to avoid N^2 hits to the db
          group.projects.each do |project|
            projects << project
          end
        end
      end
      return projects
    end

    # Get the most active projects.
    def top_active_projects(account)
      return nil if account.nil?
      top_active = nil
      if account.is_a?(Worker)
        if account.has_role?(Role::ADMIN)
           top_active = self.all(:limit => Project::NUMBER_OF_TOP_ACTIVE_PROJECTS, :order => "activity DESC")
        else
          worker_group_ids = account.worker_groups.collect {|g| g.id}
          top_active = self.all(:conditions => {:worker_group_id => worker_group_ids}, :limit => Project::NUMBER_OF_TOP_ACTIVE_PROJECTS, :order => "activity DESC")
        end
      else
        client_group_ids = account.client_groups.collect {|g| g.id}
         top_active = self.all(:conditions => {:client_group_id => client_group_ids}, :limit => Project::NUMBER_OF_TOP_ACTIVE_PROJECTS, :order => "activity DESC")
      end
      return top_active
    end

    # Update activity levels of all open projects.
    def update_activity
      projects = Project.all
      projects.each do |project|
        project.update_attribute(:activity, project.recalculate_activity())
      end
    end
  end

  # Recalulate the activity of a project.
  def recalculate_activity
    activity = Task.recent_count(self.id)
    activity += ClientRequest.recent_count(self.milestones)
    activity += Message.recent_count(self)
    # TODO Count recent timesheet entries
    return activity
  end

  # Check if the specified account is allowed to access this project.
  def allows_access?(account)
    return false if account.nil?
    if(account.is_a? Worker) then 
      return true if account.has_role?(Role::ADMIN)
      worker_group_ids = account.worker_groups.collect {|g| g.id}
      return worker_group_ids.include?(self.worker_group_id)
    else
      client_group_ids = account.client_groups.collect {|g| g.id}
      return client_group_ids.include?(self.client_group_id)
    end
  end
  
  #convenience method to collect workers for a project  
  def workers
    worker_group.accounts
  end

  def clients
    client_group.accounts
  end

  def manager
    self.workers.each do |worker|
      if worker.has_role?(Role::MANAGER)
         return worker
      end
    end
    return nil
  end


  def total_billed_hours
    task_ids = self.tasks.all(:select => "id")
    BillableTime.sum("billed_hour", :conditions => {:task_id => task_ids})
  end

end

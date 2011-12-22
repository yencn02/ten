class Worker < Account
#  belongs_to :project
  has_many :tasks
  
  validates :worker_groups, :presence => true

  def admin_worker_path
    return "/admin/workers/#{self.id}"
  end

  def projects
    projects = []
    worker_groups.each do |group|
      projects.concat(group.projects)
    end
    projects
  end

  def project_ids
    self.projects.map{|x| x.id}
  end
  
  # Paginate workers ordered by activity.
  def self.paginate_by_activity(account, page, per_page = $menu_number_of_workers)
    return nil if account.nil?
    case
    when account.is_a?(Worker)
      if account.has_role?(Role::ADMIN)
        workers = self.paginate :page => page, :conditions => {:enabled => true},
          :per_page => per_page, :order => "activity DESC"
      else
        worker_ids = account.worker_ids()
        workers = self.paginate :page => page, :per_page => per_page,
          :conditions => {:id => worker_ids, :enabled => true}, :order => "activity DESC"
      end
    end
    return workers
  end
  
   def messages(status, page, per_page)
     conditions = {"message_statuses.account_id" => self.id }
     conditions["message_statuses.status"] = status unless status.eql?("all")     
     Message.joins(:message_statuses).paginate(:page => page, :per_page => per_page, :conditions =>  conditions, :order => "created_at DESC")
  end
  
   def client_messages(status, page, per_page)     
     conditions = {"client_message_statuses.account_id" => self.id }
     conditions["client_message_statuses.status"] = status unless status.eql?("all")     
     ClientMessage.joins(:client_message_statuses).paginate(:page => page, :per_page => per_page, :conditions =>  conditions, :order => "created_at DESC")
   end
    
  # Get a list of IDs of workers who work in the same groups with the specified a account
  def worker_ids()
    worker_list = Array.new
    # Find all the workers who are assigned to the same groups with the current lead
    self.worker_groups.each do |group|
      worker_list.concat(group.accounts)
    end
    return worker_list.collect {|worker| worker.id}
  end
  
  # Return a worker with the least assigned hours in the specified project.
  # Return nil if no worker is found.
  def self.worker_with_least_assigned_hours(project_id)
    hours = worker_with_no_tasks_assigned(project_id)    
    unless hours.nil?
      return hours
    end
   #workload = Task.where("status = ? AND project_id = ?", :assigned.to_s, project_id).includes(:worker).group("worker_id").order("workload ASC").select("worker_id, SUM(estimated_hours) AS workload")
    workload = Task.first(
    :select => "worker_id, SUM(estimated_hours) AS workload",    
    :include => :worker,
    :conditions => ["status = ? AND project_id = ?", :assigned.to_s, project_id],
    :group => "worker_id",
    :order => "workload ASC")
   
    unless workload.nil?
      return Worker.find(workload.worker_id)
    end
    return hours
  end
  
  # Find a worker who has no tasks assigned or has completed all her tasks in a project.
  def self.worker_with_no_tasks_assigned(project_id)    
    project = Project.find(project_id)  
    workers = project.worker_group.accounts        
    workers.each do |worker|
      task = Task.where("project_id = ? AND worker_id = ? AND status = ?", project_id, worker.id, 'assigned').first()
      return worker if task.nil?       
    end
  
    return nil
  end

  def total_billed_hours
    task_ids = self.tasks.all(:select => "id")
    BillableTime.sum("billed_hour", :conditions => {:task_id => task_ids})
  end

  def billed_hours_on_project(project_id)
    task_ids = self.tasks.all(:select => "id", :conditions => {:project_id => project_id})
    BillableTime.sum("billed_hour", :conditions => {:task_id => task_ids})
  end

end

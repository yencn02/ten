class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :client_requests, :dependent => :delete_all

  validates :title, :presence => true
  validates_length_of :title, :within => 3..255
  validates :due_date, :presence => true
  validates :project, :presence => true
  
  class << self
    def milestone_by_due_date(project_id = nil)
      milestones = nil
      if(project_id.nil? or project_id =="all")
        milestones = Milestone.all(:order => "due_date ASC")
      else
        milestones = Milestone.all(:conditions => {:project_id => project_id}, :order => "due_date ASC")
      end
      return milestones
    end
  end
	
  def due?
    return (self.due_date < Date.today)
  end

  def near?
    return ((self.due_date > Date.today) and (self.due_date < (Date.today + $near_milestone.to_i)))
  end
		
  def far?
    return (self.due_date > (Date.today + $near_milestone.to_i))
  end
		
  def get_task_list
    tasks = Array.new
    client_requests.each do |cr|
      tasks << cr.task if cr.task != nil
    end
    return tasks
  end

  def get_feature_list
    return client_requests
  end


end

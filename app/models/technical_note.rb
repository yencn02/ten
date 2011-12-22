class TechnicalNote < ActiveRecord::Base
  belongs_to :task
  validates_presence_of :description
  validates_presence_of :task

  # Check if the specified account is allowed to update a technical note.
  def allows_update?(account)    
    return self.task.allows_update?(account)
  end

  class << self
    def paginate_by_task(task_id, c_page, per_page = 3)            
      tech = TechnicalNote.order("created_at DESC").page(c_page).per(per_page).where("task_id =?", task_id)
      puts tech.inspect
      return tech
    end
  end
end

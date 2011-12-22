class BillableTime < ActiveRecord::Base
  # Model relationship
  belongs_to :task
  # Attribute validation
  validates :description, :presence => true
  validates :commit_hash, :presence => {:if => Proc.new { |bill| bill.completed }}
  validates_numericality_of :billed_hour

  attr_accessor :completed
  # Save billable time with a security check which ensures that the specified account is allowed to
  # add billable time to the specified task.
  def save_with_security_check(current_account) 
    task = Task.find(self.task_id)    
    if task.allows_access?(current_account)
      self.save
    else
      message = "The specified account [id: #{current_account.id}] "
      message << "is not allowed to access this task [id: #{task.id}]."
      raise SecurityError, message
    end
  end

  protected
  def validate
    validates_billed_hour()
  end

  private
  # Validate if billed_hour is a multiple of 15 minutes.
  def validates_billed_hour
    unless billed_hour.nil?
      unless billed_hour.modulo(0.25) == 0.0
        errors.add(:billed_hour, "must be a multiple of 0.25 hour (15 minutes).")
      end
    end
  end
end

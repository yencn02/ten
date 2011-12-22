class ModifyTaskModel < ActiveRecord::Migration
  def self.up
    change_column(:tasks, :estimated_hours, :float, :default => 4, :null => true)
    change_column(:tasks, :start_date, :datetime, :null => true)
    change_column(:tasks, :due_date, :datetime, :null => true)
  end

  def self.down
    change_column(:tasks, :estimated_hours, :float, :default => 4, :null => false)
    change_column(:tasks, :start_date, :datetime, :null => false)
    change_column(:tasks, :due_date, :datetime, :null => false)
  end
end

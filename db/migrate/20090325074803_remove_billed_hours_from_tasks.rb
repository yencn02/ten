class RemoveBilledHoursFromTasks < ActiveRecord::Migration
  def self.up
    remove_column "tasks", "billed_hours"
  end

  def self.down
    add_column "tasks", "billed_hours", :float, :null => false, :default => 0.0
  end
end

class RemoveNotesFromTasks < ActiveRecord::Migration
  def self.up
    remove_column "tasks", "notes"
  end

  def self.down
    add_column "tasks", "notes", :text, :null => false
  end
end

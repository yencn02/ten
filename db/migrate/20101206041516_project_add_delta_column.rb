class ProjectAddDeltaColumn < ActiveRecord::Migration
  def self.up
    add_column :projects, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :projects, :delta
  end
end

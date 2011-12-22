class AddActivityToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :activity, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :activity
  end
end

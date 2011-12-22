class BillableTimeAddCommitHash < ActiveRecord::Migration
  def self.up
    add_column :billable_time, :commit_hash, :string
  end

  def self.down
    remove_column :billable_time, :commit_hash, :string
  end
end

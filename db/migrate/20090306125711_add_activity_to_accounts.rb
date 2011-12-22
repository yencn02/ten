class AddActivityToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :activity, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :activity
  end
end

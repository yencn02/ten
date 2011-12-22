class AddEnabledColumnToCompany < ActiveRecord::Migration
  def self.up
    add_column :client_companies, :enabled, :boolean, :default => true
    add_column :companies, :enabled, :boolean, :default => true
  end

  def self.down
    remove_column :client_companies, :enabled
    remove_column :companies, :enabled
  end
end

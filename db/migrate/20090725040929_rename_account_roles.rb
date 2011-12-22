class RenameAccountRoles < ActiveRecord::Migration
  def self.up
    rename_column(:account_roles, :account_id, :worker_id)    
    rename_table(:account_roles, :worker_roles)
  end

  def self.down
    rename_table(:worker_roles, :account_roles)
    rename_column(:account_roles, :worker_id, :account_id)    
  end
end

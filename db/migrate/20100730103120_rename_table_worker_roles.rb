class RenameTableWorkerRoles < ActiveRecord::Migration
  def self.up
    rename_table :worker_roles, :roles_workers
  end

  def self.down
    rename_table :roles_workers, :worker_roles
  end
end

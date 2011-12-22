class UpdateTableRolesWorkers < ActiveRecord::Migration
  def self.up
    # generate the join table
    drop_table :roles_workers
    create_table "accounts_roles", :id => false do |t|
      t.integer "account_id", "role_id"
    end
    add_index "accounts_roles", "role_id"
    add_index "accounts_roles", "account_id"
  end

  def self.down
    create_table "roles_workers", :id => false do |t|
      t.integer "role_id", "worker_id"
    end
    drop_table "roles"
    drop_table "accounts_roles"
  end
end
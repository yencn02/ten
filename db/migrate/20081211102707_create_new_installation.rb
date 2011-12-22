class CreateNewInstallation < ActiveRecord::Migration
  def self.up

    create_table "accounts", :force => true do |t|
      t.string "login", :unique => true, :limit => 32, :null => false
      t.string "name", :limit => 64, :null => false
      t.string "email", :limit => 32, :null => false
      t.string "address", :limit => 255
      t.string "phone", :limit => 16
      t.string "link", :limit => 64
      t.text "description"
      t.string "crypted_password", :limit => 64, :null => false
      t.string "salt", :limit => 64
      t.boolean "enabled", :default => false
      t.string "remember_token", :limit => 64
      t.datetime "remember_token_expires_at"
      t.string "type", :limit => 32, :null => false, :default => "Account"
      t.timestamps
    end
    add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

    create_table "roles", :force => true do |t|
      t.string "name", :unique => true, :limit => 32, :null => false
    end

    create_table "account_roles", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "account_id"
    end

    create_table "client_companies", :force => true do |t|
      t.string "name", :unique => true, :limit => 32, :null => false
      t.text "description"
      t.timestamps
    end
    add_index "client_companies", ["name"], :name => "index_client_companies_on_name", :unique => true

    create_table "client_groups", :force => true do |t|
      t.string "name", :unique => true, :null => false
      t.text "description"
      t.integer "client_company_id", :null => false
      t.timestamps
    end
    add_index "client_groups", ["name"], :name => "index_client_groups_on_name", :unique => true

    create_table "client_group_accounts", :id => false, :force => true do |t|
      t.integer "account_id", :null => false
      t.integer "client_group_id", :null => false
    end

    create_table "companies", :force => true do |t|
      t.string "name", :unique => true, :limit => 255, :null => false
      t.text "description"
      t.timestamps
    end
    add_index "companies", ["name"], :name => "index_companies_on_name", :unique => true

    create_table "worker_groups", :force => true do |t|
      t.string "name", :unique => true, :limit => 32, :null => false
      t.text "description"
      t.integer "company_id", :null => false
      t.timestamps
    end
    add_index "worker_groups", ["name"], :name => "index_worker_groups_on_name", :unique => true

    create_table "worker_group_accounts", :id => false, :force => true do |t|
      t.integer "account_id", :null => false
      t.integer "worker_group_id", :null => false
    end

    create_table "projects", :force => true do |t|
      t.string "name", :unique => true, :limit => 32, :null => false
      t.text "description", :null => false
      t.integer "client_group_id", :null => false
      t.integer "worker_group_id", :null => false
      t.timestamps
    end
    add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

    create_table "milestones", :force => true do |t|
      t.string "title", :limit => 255,  :null => false
      t.date "due_date", :null => false
      t.integer "project_id", :null => false
      t.timestamps
    end

    create_table "requirements", :force => true do |t|
      t.string "title", :limit => 255, :null => false
      t.text "description", :null => false
      t.integer "priority", :null => false, :default => 0
      t.string "status", :limit => 64
      t.integer "milestone_id", :null => false
      t.timestamps
    end

    create_table "requirement_changes", :force => true do |t|
      t.text "description", :null => false
      t.integer "requirement_id", :null => false
      t.timestamps
    end

    create_table "tasks", :force => true do |t|
      t.string "title", :limit => 255
      t.float "estimated_hours", :null => false, :default => 4.0
      t.float "billed_hours", :null => false, :default => 0
      t.date "start_date", :null => false
      t.date "due_date", :null => false
      t.text "notes", :null => false
      t.string "status", :null => false
      t.integer "project_id",  :null => false
      t.integer "requirement_id"
      t.integer "worker_id", :references => "accounts"
      t.timestamps
    end

    create_table "attached_files", :force => true do |t|
      t.text "description"
      t.string "filename", :limit => 255
      t.integer "size"
      t.string "content_type"
      t.integer "width"
      t.integer "height"
      t.integer "parent_id", :references => "attached_files"
      t.string "thumbnail", :limit => 255
      t.integer "milestone_id"
      t.integer "requirement_id"
      t.integer "task_id"
      t.timestamps
    end

    create_table "messages", :force => true do |t|
      t.string "title", :limit => 255
      t.text "body", :null => false
      t.integer  "reply_to", :references => "messages"
      t.integer  "sender_id", :null => false, :references => "accounts"
      t.integer  "requirement_id"
      t.integer  "task_id"
      t.integer  "milestone_id"
      t.timestamps
    end
  end

  def self.down
    drop_table "accounts"
    drop_table "roles"
    drop_table "account_roles"
    drop_table "client_companies"
    drop_table "client_groups"
    drop_table "client_group_accounts"
    drop_table "companies"
    drop_table "worker_groups"
    drop_table "worker_group_accounts"
    drop_table "projects"
    drop_table "milestones"
    drop_table "requirements"
    drop_table "requirement_changes"
    drop_table "tasks"
    drop_table "messages"
    drop_table "attached_files"
  end
end

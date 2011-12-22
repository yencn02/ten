# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110516194823) do

  create_table "accounts", :force => true do |t|
    t.string   "login",                     :limit => 32,                        :null => false
    t.string   "name",                      :limit => 64,                        :null => false
    t.string   "email",                     :limit => 32,                        :null => false
    t.string   "address"
    t.string   "phone",                     :limit => 16
    t.string   "link",                      :limit => 64
    t.text     "description"
    t.string   "crypted_password",          :limit => 64,                        :null => false
    t.string   "salt",                      :limit => 64
    t.boolean  "enabled",                                 :default => false
    t.string   "remember_token",            :limit => 64
    t.datetime "remember_token_expires_at"
    t.string   "type",                      :limit => 32, :default => "Account", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity",                                :default => 0
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

  create_table "accounts_roles", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "role_id"
  end

  add_index "accounts_roles", ["role_id"], :name => "index_accounts_roles_on_role_id"
  add_index "accounts_roles", ["account_id"], :name => "index_accounts_roles_on_account_id"

  create_table "attached_files", :force => true do |t|
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "milestone_id"
    t.integer  "client_request_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
  end

  create_table "bdrb_job_queues", :force => true do |t|
    t.binary   "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "billable_time", :force => true do |t|
    t.text     "description",                  :null => false
    t.float    "billed_hour", :default => 0.0, :null => false
    t.integer  "task_id",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commit_hash"
  end

  create_table "client_companies", :force => true do |t|
    t.string   "name",        :limit => 32,                   :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",                   :default => true
  end

  add_index "client_companies", ["name"], :name => "index_client_companies_on_name", :unique => true

  create_table "client_group_accounts", :id => false, :force => true do |t|
    t.integer "account_id",      :null => false
    t.integer "client_group_id", :null => false
  end

  create_table "client_groups", :force => true do |t|
    t.string   "name",              :null => false
    t.text     "description"
    t.integer  "client_company_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_message_statuses", :force => true do |t|
    t.string   "status",            :null => false
    t.integer  "client_message_id", :null => false
    t.integer  "account_id",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_messages", :force => true do |t|
    t.string   "title",             :null => false
    t.text     "body"
    t.integer  "sender_id",         :null => false
    t.integer  "client_request_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_request_changes", :force => true do |t|
    t.text     "description",       :null => false
    t.integer  "client_request_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_requests", :force => true do |t|
    t.string   "title",                                     :null => false
    t.text     "description",                               :null => false
    t.integer  "priority",                   :default => 0, :null => false
    t.string   "status",       :limit => 64
    t.integer  "milestone_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name",                          :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",     :default => true
  end

  add_index "companies", ["name"], :name => "index_companies_on_name", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"
  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"

  create_table "message_statuses", :force => true do |t|
    t.string   "status",     :null => false
    t.integer  "message_id", :null => false
    t.integer  "account_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.text     "body",       :null => false
    t.integer  "sender_id",  :null => false
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", :force => true do |t|
    t.string   "title",      :null => false
    t.date     "due_date",   :null => false
    t.integer  "project_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",            :limit => 32,                   :null => false
    t.text     "description",                                     :null => false
    t.integer  "client_group_id",                                 :null => false
    t.integer  "worker_group_id",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity",                      :default => 0
    t.string   "status"
    t.boolean  "delta",                         :default => true, :null => false
  end

  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

  create_table "roles", :force => true do |t|
    t.string "name", :limit => 32, :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.float    "estimated_hours",   :default => 4.0
    t.datetime "start_date"
    t.datetime "due_date"
    t.string   "status",                             :null => false
    t.integer  "project_id",                         :null => false
    t.integer  "client_request_id"
    t.integer  "worker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technical_notes", :force => true do |t|
    t.text     "description", :null => false
    t.integer  "task_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worker_group_accounts", :id => false, :force => true do |t|
    t.integer "account_id",      :null => false
    t.integer "worker_group_id", :null => false
  end

  create_table "worker_groups", :force => true do |t|
    t.string   "name",        :limit => 32, :null => false
    t.text     "description"
    t.integer  "company_id",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "worker_groups", ["name"], :name => "index_worker_groups_on_name", :unique => true

end

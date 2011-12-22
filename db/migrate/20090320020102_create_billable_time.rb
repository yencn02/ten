class CreateBillableTime < ActiveRecord::Migration
  def self.up
    create_table :billable_time do |t|
      t.text "description", :null => false
      t.float "billed_hour", :null => false, :default => 0
      t.integer "task_id", :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :billable_time
  end
end

class CreateMessageStatuses < ActiveRecord::Migration
  def self.up
    create_table :message_statuses do |t|
      t.string :status, :null => false
      t.integer :message_id, :null => false
      t.integer :account_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :message_statuses
  end
end

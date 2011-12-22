class CreateClientMessageStatuses < ActiveRecord::Migration
  def self.up
    create_table :client_message_statuses do |t|
      t.string :status, :null => false
      t.integer :client_message_id, :null => false
      t.integer :account_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :client_message_statuses
  end
end

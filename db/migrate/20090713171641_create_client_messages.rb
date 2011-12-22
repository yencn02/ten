class CreateClientMessages < ActiveRecord::Migration
  def self.up
    create_table :client_messages do |t|
					 t.string :title, :null => false
      t.text :body
      t.integer :sender_id, :null => false
      t.integer :client_request_id, :null => false
      t.string :status
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :client_messages
  end
end

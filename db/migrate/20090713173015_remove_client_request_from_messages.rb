class RemoveClientRequestFromMessages < ActiveRecord::Migration
  def self.up
    remove_column :messages, :client_request_id
    remove_column :messages, :milestone_id
  end

  def self.down
    add_column :messages, :milestone_id, :integer
    add_column :messages, :client_request_id, :integer
  end		
end

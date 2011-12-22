class RemoveStatusFromClientMessage < ActiveRecord::Migration
  def self.up
    remove_column :client_messages, :status
  end

  def self.down
    add_column :client_messages, :status, :string
  end
end

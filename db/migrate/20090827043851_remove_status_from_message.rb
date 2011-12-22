class RemoveStatusFromMessage < ActiveRecord::Migration
  def self.up
    remove_column :messages, :status
  end

  def self.down
    add_column :messages, :status, :string
  end
end

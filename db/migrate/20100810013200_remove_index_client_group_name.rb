class RemoveIndexClientGroupName < ActiveRecord::Migration
  def self.up
    remove_index "client_groups", "name"
  end

  def self.down
    add_index "client_groups", "name", :name => "index_client_groups_on_name"
  end
end

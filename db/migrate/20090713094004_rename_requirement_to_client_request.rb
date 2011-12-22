class RenameRequirementToClientRequest < ActiveRecord::Migration
  def self.up
			rename_table :requirements, :client_requests
			rename_table :requirement_changes, :client_request_changes

			rename_column :attached_files, :requirement_id, :client_request_id 
			rename_column :messages, :requirement_id, :client_request_id 
			rename_column :client_request_changes, :requirement_id, :client_request_id
			rename_column :tasks, :requirement_id, :client_request_id 
  end

  def self.down
			rename_table :client_requests, :requirements
			rename_table :client_request_changes, :requirement_changes
			
			rename_column :attached_files, :client_request_id, :requirement_id  
			rename_column :messages, :client_request_id, :requirement_id  
			rename_column :client_request_changes, :requirement_id, :client_request_id 
			rename_column :tasks, :client_request_id, :requirement_id  
  end
end

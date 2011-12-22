class AttachFileUsePaperclip < ActiveRecord::Migration
  def self.up
    remove_column :attached_files, :filename
    remove_column :attached_files, :size
    remove_column :attached_files, :content_type
    remove_column :attached_files, :width
    remove_column :attached_files, :height
    remove_column :attached_files, :thumbnail
    add_column :attached_files, :file_file_name, :string
    add_column :attached_files, :file_content_type, :string
    add_column :attached_files, :file_file_size, :integer    
  end

  def self.down
    add_column :attached_files, :filename, :string
    add_column :attached_files, :size, :integer
    add_column :attached_files, :content_type, :string
    add_column :attached_files, :width, :integer
    add_column :attached_files, :height, :integer
    add_column :attached_files, :thumbnail, :string
    remove_column :attached_files, :file_file_name
    remove_column :attached_files, :file_content_type
    remove_column :attached_files, :file_file_size
  end
end

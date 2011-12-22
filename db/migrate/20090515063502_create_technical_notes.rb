class CreateTechnicalNotes < ActiveRecord::Migration
  def self.up
    create_table :technical_notes, :force => true do |t|
      t.text "description", :null => false
      t.integer "task_id", :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :technical_notes
  end
end

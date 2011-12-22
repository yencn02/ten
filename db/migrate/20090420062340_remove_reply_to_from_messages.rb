class RemoveReplyToFromMessages < ActiveRecord::Migration
  def self.up
    remove_column "messages", "reply_to"
  end

  def self.down
    add_column "messages", "reply_to", :integer, :references => "messages"
  end
end

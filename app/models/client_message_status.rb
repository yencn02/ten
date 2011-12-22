require "aasm" unless defined?(AASM)
class ClientMessageStatus < ActiveRecord::Base
  include AASM
  belongs_to :client_message
  belongs_to :account

  scope :status_for, lambda {|account|  { :conditions => ["account_id = ?", account.id] }}
  
  STATUSES = [:read, :unread, :archived]
  READ = "read"
  UNREAD = "unread"
  ARCHIVED = "archived"

  # AASM (Acts As State Machine) Configuration
  aasm_column :status
  aasm_initial_state :unread
  aasm_state :unread
  aasm_state :read
  aasm_state :archived

  aasm_event :read do
    transitions :to => :read, :from => [:unread]
  end

  aasm_event :archive do
    transitions :to => :archived, :from => [:read, :unread]
  end

  validates_presence_of :status
  validates_presence_of :client_message
  validates_presence_of :account  
end

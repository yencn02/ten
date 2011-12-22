require 'digest/sha1'

class Account < ActiveRecord::Base

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_and_belongs_to_many :roles
  has_many :client_group_accounts, :dependent => :delete_all
  has_many :client_groups, :through => :client_group_accounts
  has_many :worker_group_accounts, :dependent => :delete_all
  has_many :worker_groups, :through => :worker_group_accounts

  has_many :message_statuses  
  #has_many :messages, :through => :message_statuses    
  has_many :top_messages, :through => :message_statuses, :source =>:message, 
    :conditions => [ "status = ? or status =?", MessageStatus::READ, MessageStatus::UNREAD], :order => "created_at DESC", :limit => 20 
  has_many :read_messages, :through => :message_statuses, :source =>:message, :conditions => [ "status = ?", MessageStatus::READ],:order => "created_at DESC"
  has_many :unread_messages, :through => :message_statuses, :source =>:message, :conditions => [ "status = ?", MessageStatus::UNREAD],:order => "created_at DESC"
  has_many :archived_messages, :through => :message_statuses, :source =>:message, :conditions => [ "status = ?", MessageStatus::ARCHIVED],:order => "created_at DESC"

  has_many :client_message_statuses  
  #has_many :client_messages, :through => :client_message_statuses
  has_many :top_client_messages, :through => :client_message_statuses,  :source => :client_message,
    :conditions => [ "status = ? or status =?", MessageStatus::READ, MessageStatus::UNREAD], :order => "created_at DESC", :limit => 20
  has_many :all_client_messages, :through => :client_message_statuses,  :source => :client_message, 
    :conditions => [ "status = ? or status =? or status =?", MessageStatus::READ, MessageStatus::UNREAD, MessageStatus::ARCHIVED], :order => "created_at DESC", :limit => 20 
  has_many :read_client_messages, :through => :client_message_statuses, :source => :client_message, :conditions => [ "status = ?", ClientMessageStatus::READ ],:order => "created_at DESC"
  has_many :unread_client_messages, :through => :client_message_statuses, :source => :client_message, :conditions => [ "status = ?", ClientMessageStatus::UNREAD ],:order => "created_at DESC"
  has_many :archived_client_messages, :through => :client_message_statuses, :source => :client_message, :conditions => [ "status = ?", ClientMessageStatus::ARCHIVED],:order => "created_at DESC"

  validates :roles, :presence => true
  validates_length_of :address, :maximum => 255, :allow_nil => true
  validates :email, :presence => true
  validates_length_of :email, :within => 6..32 #r@a.wk
  validates_uniqueness_of :email
  validates_format_of :email,
    :with => Authentication.email_regex,
    :message => Authentication.bad_email_message
  validates_length_of :link, :maximum => 255, :allow_nil => true
  validates :login, :presence => true
  validates_length_of :login, :within => 3..32
  validates_format_of :login,
    :with => Authentication.login_regex,
    :message => Authentication.bad_login_message
  validates_uniqueness_of :login
  validates_format_of :name,
    :with => Authentication.name_regex,
    :message => Authentication.bad_name_message,
    :allow_nil => true
  validates_length_of :name, :within => 2..64
  validates_length_of :phone, :maximum => 16, :allow_nil => true

  ## HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :address, :description, :email, :enabled, :link, :login, :name, :password,
    :password_confirmation, :phone, :role_id, :worker_groups

  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?(Role::ADMIN)
    if role_in_question != Role::CLIENT
      (@_list.include?(role_in_question.to_s) )
    else
      self.read_attribute(:type) == Client.to_s ? true : false
    end
  end
  

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    user = self.find_by_login(login, :conditions => {:enabled => true}) # need to get the salt
    user && user.authenticated?(password) ? user : nil
  end



  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # Enforce caller classes to use concrete classes which extend Account rather than using Account
  # (designed as an abstract class) directly.
  def self.new(attributes = nil)
    raise "Account is abstract, you cannot instantiate it directly" if self.to_s == "Account"
    super(attributes)
  end  

end

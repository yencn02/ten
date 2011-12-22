class ClientGroup < ActiveRecord::Base
  #### Model relationship
  has_many :client_group_accounts
  has_many :accounts, :through => :client_group_accounts
  has_many :projects
  belongs_to :client_company
  validates_presence_of :client_company_id
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :client_company_id
  def admin_client_group_path
    "/admin/client_groups/#{self.id}"
  end
  
  def extend_name
    "#{self.client_company.name} - #{self.name}"
  end
end

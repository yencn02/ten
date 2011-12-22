class WorkerGroup < ActiveRecord::Base
  # Model relationship
  has_many :worker_group_accounts
  has_many :accounts, :through => :worker_group_accounts
  has_many :projects
  belongs_to :company
  validates_presence_of :company_id
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :company_id
  def admin_worker_group_path
    "/admin/worker_groups/#{self.id}"
  end
end

class Role < ActiveRecord::Base
  #TODO - Why are there both constants and records here? what happens if they get out of sync?
  ADMIN = "admin"
  MANAGER = "manager"
  LEAD = "leader"
  WORKER = "worker"
  CLIENT = "client"
#  has_many :worker_roles
  has_and_belongs_to_many :accounts
#  has_many :workers, :through => :worker_roles
  #Get all worker roles for a Worker: worker has not role of Admin & Client
  def self.worker_roles
    self.all(:conditions => ["name not in(?)", [ADMIN, CLIENT]])
  end
end
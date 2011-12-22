class Company < ActiveRecord::Base
  has_many :worker_groups
  validates_presence_of :name
  validates_length_of :name, :within => 1..32
  validates_uniqueness_of :name
  def admin_company_path
    "/admin/companies/#{self.id}"
  end
end

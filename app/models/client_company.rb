class ClientCompany < ActiveRecord::Base
  has_many :client_groups, :dependent => :delete_all
  validates :name, :presence => true
  validates_length_of :name, :within => 1..32
  validates_uniqueness_of :name
  def admin_client_company_path
    "/admin/client_companies/#{self.id}"
  end
end

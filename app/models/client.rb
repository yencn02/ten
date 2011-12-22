class Client < Account
  NUMBER_OF_TOP_PROJECTS = 3
  validates_presence_of :client_groups

  def admin_client_path
    return "/admin/clients/#{self.id}"
  end

  def project_ids
    project_ids = []
    client_groups.each do |group|
      project_ids.concat(group.projects.map { |x|  x.id})
    end
    project_ids
  end
end

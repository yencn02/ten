Factory.sequence(:project_name) {|n| "Project #{n}"}

Factory.define :project, :class =>Project do |p|
  p.name { Factory.next :project_name }
  p.description { "Project description" }
  p.status "active"
  p.association :worker_group, :factory => :worker_group
  p.association :client_group, :factory => :client_group
end

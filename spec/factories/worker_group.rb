Factory.sequence(:worker_group_name) {|n| "Worker Group #{n}"}

Factory.define :worker_group, :class => WorkerGroup do |group|
  group.name { Factory.next :worker_group_name }
  group.description "Worker group description"
  group.association :company, :factory => :company
end


Factory.sequence(:client_group_name) {|n| "Client Group #{n}"}

Factory.define :client_group do |group|
  group.name { Factory.next :client_group_name }
  group.description "Client group description"
  group.association :client_company, :factory => :client_company
end

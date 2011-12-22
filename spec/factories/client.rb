Factory.sequence(:login) {|n| "login#{n}"}
Factory.sequence(:client_name) {|n| "Client #{n}"}

Factory.define :client do |client|
  client.login { Factory.next :login }
  client.name { Factory.next :client_name }
  client.password "123456"
  client.enabled true
  client.roles { [Factory(:role, :name => Role::CLIENT)] }
  client.password_confirmation { |w| w.password }
  client.email { |w| w.login + "@intel.com" }
	client.client_groups { [Factory(:client_group)] }
end

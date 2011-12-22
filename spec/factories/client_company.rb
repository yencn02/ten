Factory.sequence(:client_company_name) {|n| "Client Company #{n}"}

Factory.define :client_company do |company|
  company.name { Factory.next :client_company_name }
  company.description "Client company description"
end

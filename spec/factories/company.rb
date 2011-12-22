Factory.sequence(:company_name) {|n| "Company #{n}"}

Factory.define :company, :class => Company do |company|
  company.name { Factory.next :company_name }
  company.description "Company description"
end


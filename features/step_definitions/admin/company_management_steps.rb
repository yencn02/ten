Then /^there is a "([^\"]*)" group for "([^\"]*)" named "([^\"]*)"$/ do |group, company_name, group_name|
  company = ClientCompany.find_by_name(company_name)
  company.client_groups[0].name.should == "Default"
end
Then /^the client company "([^\"]*)" is "([^\"]*)"$/ do |company_name, status|
  status_map = {"Active" => true, "Inactive" => false}
  company = ClientCompany.find_by_name(company_name)
  company.enabled.should == status_map[status]
end
Given /^a client named "([^\"]*)"$/ do |name|
  @client = Factory.create(:client, :name => name, :client_groups => [@client_group])
end
Then /^I should see the "([^"]*)" as "([^"]*)"$/ do |client_company_name, status|
  status_map = {"Active" => true, "Inactive" => false}
  company = ClientCompany.find_by_name(client_company_name)
  company.enabled.should == status_map[status]
end

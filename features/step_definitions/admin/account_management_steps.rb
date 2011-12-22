Given /^there is a "([^"]*)" called "([^"]*)"$/ do |object, name|
  case object
  when "Company"
    @company = Factory.create(:company, :name => name)
  when "Client Company"
    @company = Factory.create(:client_company, :name => name)
  when "Role"
    Factory.create(:role, :name => name)
  else
    pedding
  end
end

Given /^there is a "([^\"]*)" named "([^\"]*)"$/ do |object, group_name|
  case object
  when "Worker Group"
    worker_group = Factory.create(:worker_group, :name => group_name, :company => @company)
    @worker_group = worker_group if worker_group.name == "Tiger"
  when "Client Group"
    @client_group = Factory.create(:client_group, :name => group_name, :client_company => @company)
  else
    pending
  end
end

Then /^the "([^"]*)" with login name "([^"]*)" and "([^"]*)" authentication should succeed$/ do |name, login, password|
  Account.authenticate(login, password).should_not be_nil
end

Then /^the "([^"]*)" named "([^"]*)" authentication should succeed$/ do |account, name|
  case account
  when "worker"
    Account.authenticate(@worker.login, @worker.password).should_not be_nil
  when "client"
    Account.authenticate(@client.login, @client.password).should_not be_nil
  else
    pending
  end
end

Then /^the "([^"]*)" named "([^"]*)" authentication should fail$/ do |account, name|
  case account
  when "worker"
    Account.authenticate(@worker.login, @worker.password).should be_nil
  when "client"
    Account.authenticate(@client.login, @client.password).should be_nil
  else
    pending
  end
end

Then /^I should see the "([^"]*)" named "([^"]*)" as "([^"]*)"$/ do |account, login, status|
  sleep 0.5
  mapping = { "Active" => true, "Inactive" => false }
  case account
  when "worker"
    if @worker
      @worker.reload.enabled.should == mapping[status]
    else
      @worker = Worker.find_by_login(login)
      @worker.enabled.should == mapping[status]
    end
  else
    @client.reload
    @client.reload.enabled.should == mapping[status]
  end
end

Given /^there is a worker named "([^"]*)" in the "([^"]*)" group for "([^"]*)"$/ do |worker_name, group_name, company_name|
  group = WorkerGroup.find_by_name(group_name)
  @worker = Factory.create(:worker, :name => worker_name, :worker_groups => [group])
end

Given /^there is a "([^"]*)" named "([^"]*)" that is "([^"]*)"$/ do |object, name, status|
  status_map = {"Active" => true, "Inactive" => false}
  case object
  when "worker"
    @worker = Factory.create(:worker, :name => name, :enabled => status_map[status])
  when "client"
    @client = Factory.create(:client, :name => name, :enabled => status_map[status])
  when "client company"
    @client_company = Factory.create(:client_company, :name => name, :enabled => status_map[status])
    @client_group = Factory.create(:client_group, :name => "Default", :client_company => @client_company)
  else
    pending
  end
end


Given /^there is a worker named "([^"]*)"$/ do |name|
  Factory.create(:worker, :name => name)
end

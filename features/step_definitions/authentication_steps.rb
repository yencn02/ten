Given /^I am logged in as a client$/ do
  @client = Factory.create(:client)
  Account.authenticate(@client.login, @client.password).should_not be_nil
  visit new_session_path
  fill_in "Login", :with => @client.login
  fill_in "Password", :with => @client.password
  click_button "Log in"
  
end

Given /^I am logged in as an admin$/ do
  @current_account = Factory.create(:admin)
  Account.authenticate(@current_account.login, @current_account.password).should_not be_nil
  visit new_session_path
  fill_in "login", :with => @current_account.login
  fill_in "password", :with => @current_account.password
  click_button "Log in"
end

Given /^I am logged in as a worker$/ do
  @current_account = Factory.create(:worker)
  Worker.authenticate(@current_account.login, @current_account.password).should_not be_nil

  visit new_session_path
  fill_in "login", :with => @current_account.login
  fill_in "password", :with => @current_account.password
  click_button "Log in"



end

Given /^I am logged in as a leader$/ do
  @current_account = Factory.create(:lead)
  Account.authenticate(@current_account.login, @current_account.password).should_not be_nil  
  visit new_session_path
  fill_in "login", :with => @current_account.login
  fill_in "password", :with => @current_account.password
  click_button "Log in"

end

Given /^I am logged in as a manager$/ do
  @current_account = Factory.create(:manager)
  Account.authenticate(@current_account.login, @current_account.password).should_not be_nil

  visit new_session_path
  fill_in "login", :with => @current_account.login
  fill_in "password", :with => @current_account.password
  click_button "Log in"
end

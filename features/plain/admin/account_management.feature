Feature: Administrator manage accounts
  In order to create and manage accounts 
  As an admin 
  I want be able to create, edit, and deactivate both worker and client accounts

  Background:
    Given I am logged in as an admin
    And there is a "Company" called "Endax"
    And there is a "Worker Group" named "Tiger"
    And there is a "Worker Group" named "Lion"
    And there is a "Client Company" called "Test Client, Inc."
    And there is a "Client Group" named "Tiger"
    And there is a "Client Group" named "Lion"
    And there is a "Role" called "Manager"
    And there is a "Role" called "Lead"
    And there is a "Role" called "Worker"
    And there is a "Role" called "Client"

  Scenario: edit a worker account 
    Given there is a worker named "Test Worker" in the "Tiger" group for "Endax"
    And I am on the "show worker" page for "Test Worker"
    When I follow "Edit"
    And I fill in "Name" with "Test Worker edited"
    And I fill in "Login" with "test_worker_edited"
    And I fill in "Email" with "test_worker@tenhqedited.com"
    And I fill in "Address" with "123 Main edited st, Brooklyn NY 11215"
    And I fill in "Phone" with "123-123-1212"
    And I fill in "Link" with "http://testlinkedited.com"
    And I fill in "Description" with "Just a edited test worker from Brooklyn"
    And I fill in "Password" with "test1234"
    And I fill in "Password confirmation" with "test1234"
    #And I select "Lion" from "Group"
    And I press "Edit"
    Then I am on the "list worker" page
    And I should see "Test Worker edited"

  Scenario: add a worker to a group
    Given there is a worker named "Test Worker"
    When I am on the "list worker groups" page 
    And I follow "Tiger" 
    And I follow "Add Worker"
    And I select "Test Worker" from "accounts"
    And I press "Add"
    Then I should be on the "show worker group" page for "Tiger"
    And I should see "Test Worker"

  Scenario: remove a worker from a group
    Given there is a worker named "Test Worker" in the "Tiger" group for "Endax"
    When I am on the "list worker groups" page 
    And I follow "Tiger" 
    And I follow "Remove Worker"
    And I select "Test Worker" from "accounts"
    And I press "Remove"
    Then I should be on the "show worker group" page for "Tiger"
    And I should not see "Test Worker"

  Scenario: edit a client account 
    Given there is a "client" named "Test client" that is "Active"
    And I am on the "show client" page for "Test client"
    When I follow "Edit"
    And I fill in "Name" with "Test client edited"
    And I fill in "Login" with "test_client_edited"
    And I fill in "Email" with "test_client@tenhqedited.com"
    And I fill in "Address" with "123 Main edited st, Brooklyn NY 11215"
    And I fill in "Phone" with "123-123-1212"
    And I fill in "Link" with "http://testlinkedited.com"
    And I fill in "Description" with "Just a edited test client from Brooklyn"
    And I fill in "Password" with "test1234"
    And I fill in "Password confirmation" with "test1234"
    And I press "Edit"
    Then I am on the "list clients" page
    And I should see "Test client edited"

  @javascript
  Scenario: add a worker account
    When I am on the "list workers" page
    And I follow "New"
    And I fill in "Name" with "Test Worker"
    And I fill in "Login" with "test_worker"
    And I fill in "Email" with "test_worker@tenhq.com"
    And I fill in "Address" with "123 Main st, Brooklyn NY 11215"
    And I fill in "Phone" with "123-123-1232"
    And I fill in "Link" with "http://testlink.com"
    And I fill in "Password" with "test123"
    And I fill in "Password Confirmation" with "test123"
    And I fill in the "worker_description" with "Just a test worker from Brooklyn"
    And I select "Endax" from "worker_company"
    And I select "Tiger" from "worker_group"
    And I select "Manager" from "worker_role"
    And I press "Create"
    Then I am on the "list worker" page
    And I should see the "worker" named "test_worker" as "Active"
    And the "Test Worker" with login name "test_worker" and "test123" authentication should succeed

  @javascript
  Scenario: deactivate a worker account
    Given there is a "worker" named "Test Worker" that is "Active"
    And I am on the "edit worker" page for "Test Worker"
    When I follow "Deactivate"
    And I select "Inactive" from "worker_enabled"
    And I press "Edit"
    Then I am on the "list worker" page
    And I should see the "worker" named "Test Worker" as "Inactive"
    And the "worker" named "Test Worker" authentication should fail

  @javascript
  Scenario: activate a worker account
    Given there is a "worker" named "Test Worker" that is "Inactive"
    And I am on the "edit worker" page for "Test Worker"
    When I follow "Activate"
    And I select "Active" from "worker_enabled"
    And I press "Edit"
    Then I am on the "list worker" page
    And I should see the "worker" named "Test Worker" as "Active"
    And the "worker" named "Test Worker" authentication should succeed

  @javascript
  Scenario: add a client account
    When I am on the "list clients" page
    And I follow "New"
    And I fill in "Name" with "Test client"
    And I fill in "Login" with "test_client"
    And I fill in "Email" with "test_client@tenhq.com"
    And I fill in "Address" with "123 Main st, Brooklyn NY 11215"
    And I fill in "Phone" with "123-123-1232"
    And I fill in "Link" with "http://testlink.com"
    And I fill in the "client_description" with "Just a test client from Brooklyn"
    And I fill in "Password" with "test123"
    And I fill in "Password Confirmation" with "test123"
    And I select "Test Client, Inc." from "client_company"
    And I select "Tiger" from "client_group"
    And I press "Create"
    Then I am on the "list clients" page
    And I should see "Test client"
    And the "Test Worker" with login name "test_client" and "test123" authentication should succeed

  @javascript
  Scenario: deactivate a client account
    Given there is a "client" named "Test client" that is "Active"
    And I am on the "edit client" page for "Test client"
    When I follow "Deactivate"
    And I select "Inactive" from "client_enabled"
    And I press "Edit"
    Then I should see the "client" named "Test client" as "Inactive"
    And the "client" named "Test client" authentication should fail

  @javascript
  Scenario: activate a client account
    Given there is a "client" named "Test client" that is "Inactive"
    And I am on the "edit client" page for "Test client"
    When I follow "Activate"
    And I select "Active" from "client_enabled"
    And I press "Edit"
    Then I should see the "client" named "Test client" as "Active"
    And the "client" named "Test client" authentication should succeed
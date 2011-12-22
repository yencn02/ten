Feature: Administrator manage companies
  In order to create and manage companies 
  As an admin 
  I want be able to create, edit, and deactivate companies and client companies

  Background:
    Given I am logged in as an admin
    
  Scenario: add a company
    When I am on the "list companies" page 
    And I follow "New"
    And I fill in "Name" with "Endax"
    And I fill in "Description" with "Badd Ass Union of Developers"
    And I press "Create"
    Then I am on the "list companies" page
    And I should see "Endax"

  Scenario: add a client company
    When I am on the "list client companies" page 
    And I follow "New"
    And I fill in "Name" with "Test Dudes, Inc."
    And I fill in "Description" with "Test client company"
    And I press "Create"
    Then I am on the "list client companies" page
    And I should see "Test Dudes, Inc."
    And there is a "Client" group for "Test Dudes, Inc." named "Default"
    And the client company "Test Dudes, Inc." is "Active"

  Scenario: deactivate a client company
    Given there is a "client company" named "Test Dudes, Inc." that is "Active"
    And a client named "Main Dude"
    When I am on the "show client company" page for "Test Dudes, Inc." 
    And I follow "Deactivate" within "#menu"
    And I am on the "confirm client company deactivation" page for "Test Dudes, Inc." 
    And I follow "Deactivate" within "#page-content"
    Then I am on the "list client companies" page
    And I should see the "Test Dudes, Inc." as "Inactive"
    And the "client" named "Main Dude" authentication should fail
    
  Scenario: activate a client company
    Given there is a "client company" named "Test Dudes, Inc." that is "Inactive"
    And a client named "Main Dude"
    When I am on the "show client company" page for "Test Dudes, Inc." 
    And I follow "Activate" within "#menu"
    And I am on the "confirm client company activation" page for "Test Dudes, Inc." 
    And I follow "Activate" within "#page-content"
    Then I am on the "list client companies" page
    And I should see the "Test Dudes, Inc." as "Active"
    And the "client" named "Main Dude" authentication should succeed




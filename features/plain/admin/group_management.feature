Feature: Administrator manage groups
  In order to create and manage groups 
  As an admin 
  I want be able to create, edit, and deactivate worker groups

  Background:
    Given I am logged in as an admin
    And there is a "Company" called "Endax"

  Scenario: add a worker group
    When I am on the "list worker groups" page 
    And I follow "New"
    And I fill in "Name" with "Tiger"
    And I fill in "Description" with "Top development crew"
    And I select "Endax" from "Company"
    And I press "Create"
    Then I am on the "list worker groups" page
    And I should see "Tiger"

  Scenario: remove a worker group
    Given there is a "Worker Group" named "Tiger"
    When I am on the "show worker group" page for "Tiger" 
    And I follow "Remove" within "#menu"
    And I am on the "confirm group removal" page for "Tiger"
    And I follow "Remove" within "#page-content"
    Then I am on the "list worker groups" page
    And I should not see "Tiger"


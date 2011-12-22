@navigation
Feature: Admin Navigation
  As an admin
  I want to be able to access the admin section and other application administration features    

  Scenario: Show the "Admin" menu item
    Given I am logged in as an admin
    Then I should see "Admin"

  Scenario: Worker can't access to Admin pages
    Given I am logged in as a worker
    Then I should not see "Admin"

  Scenario: Leader can't access to Admin pages
    Given I am logged in as a leader
    Then I should not see "Admin"

  Scenario: Manager can't access to Admin pages
    Given I am logged in as a manager
    Then I should not see "Admin"


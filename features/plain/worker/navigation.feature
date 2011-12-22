@navigation
Feature: Admin Navigation
  As a worker
  I should be able to navigate through the application with the menu

  Background:
    Given I am logged in as a worker

  Scenario: Display worker menu items
    Given I am on the home page
    Then I should see the "Task" menu item
#    Then I should see the "Milestone" menu item
    Then I should see the "Message" menu item
    Then I should see the "Time" menu item

  Scenario: Display active projects under the "Task" menu item
    Given I have the following projects
      | name        | client     | status   | description                                               |
      | Armpit Claw | John Cena  | Active   | Squeeze of the muscle in the front of the armpit          |
      | Fish Hook   | Big Show   | Active   | Bends one of the fingers into a hook                      |
      | Giant Swing | Mr. Kenedy | Inactive | Takes hold of a supine opponent's legs and pivots rapidly |
      | Sunset Flip | Triple H   | Inactive | Catch the opponent in a waistlock from behind             |
    And I am on the home page
    When I follow "Task"
    Then I should see the following menu items
      | name        |
      | Armpit Claw |
      | Fish Hook   |
    And I should not see the following menu items
      | name        |
      | Giant Swing |
      | Sunset Flip |

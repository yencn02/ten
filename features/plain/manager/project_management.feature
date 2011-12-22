Feature: Managers manage projects
  In order to manage projects
  As a manager
  I should be able to create, view, edit, activate and deactivate projects

  Background:
    Given I am logged in as a manager
    And I am on the project list page

  Scenario: Show projects
    Given I have the following projects
      | name        | client     | status   | description                                               |
      | Armpit Claw | John Cena  | Active   | Squeeze of the muscle in the front of the armpit          |
      | Fish Hook   | Big Show   | Active   | Bends one of the fingers into a hook                      |
      | Giant Swing | Mr. Kenedy | Inactive | Takes hold of a supine opponent's legs and pivots rapidly |
      | Sunset Flip | Triple H   | Inactive | Catch the opponent in a waistlock from behind             |
    When I go to the project list page
    # By default, active projects are shown
    Then I should see the following projects
      | name        | client     | status   | description                                               |
      | Armpit Claw | John Cena  | Active   | Squeeze of the muscle in the front of the armpit          |
      | Fish Hook   | Big Show   | Active   | Bends one of the fingers into a hook                      |

  Scenario: Show projects by status
    Given I have the following projects
      | name        | client     | status   | description                                               |
      | Armpit Claw | John Cena  | Active   | Squeeze of the muscle in the front of the armpit          |
      | Fish Hook   | Big Show   | Active   | Bends one of the fingers into a hook                      |
      | Giant Swing | Mr. Kenedy | Inactive | Takes hold of a supine opponent's legs and pivots rapidly |
      | Sunset Flip | Triple H   | Inactive | Catch the opponent in a waistlock from behind             |

    When I follow "Inactive"
    Then I should see the following projects
      | name        | client     | status   | description                                               |
      | Giant Swing | Mr. Kenedy | Inactive | Takes hold of a supine opponent's legs and pivots rapidly |
      | Sunset Flip | Triple H   | Inactive | Catch the opponent in a waistlock from behind             |

    When I follow "Active"
    Then I should see the following projects
      | name        | client     | status   | description                                               |
      | Armpit Claw | John Cena  | Active   | Squeeze of the muscle in the front of the armpit          |
      | Fish Hook   | Big Show   | Active   | Bends one of the fingers into a hook                      |

  @javascript
  Scenario: Create and activate a project
    Given I am a member of the following worker groups
      | name  |
      | Bear  |
      | Tiger |
      | Wolf  |
    And we have following clients 
      | name       |
      | John Cena  |
      | Big Show   |
      | Mr. Kenedy |
      
    When I follow "New"
    And I fill in "Name" with "Butterfly" within "#facebox"
    And I fill in "Description" with "Technically known as a double underhook" within "#facebox"
    And I select "Wolf" from "Worker Group" within "#facebox"
    And I select "John Cena" from "Client Group" within "#facebox"
    And I check "project[status]" within "#facebox"
    And I press "Create" within "#facebox"
    And I should see "Butterfly"
    And I should see "Technically known as a double underhook"
    And I should see "Wolf"

  @javascript
  Scenario: Create and deactivate a project
    Given I am a member of the following worker groups
      | name  |
      | Bear  |
      | Tiger |
      | Wolf  |
    And we have following clients 
      | name       |
      | John Cena  |
      | Big Show   |
      | Mr. Kenedy |

    When I follow "New"
    And I fill in "Name" with "Butterfly"
    And I fill in "Description" with "Technically known as a double underhook"
    And I select "Wolf" from "Worker Group"
    And I select "John Cena" from "Client Group"
    And I press "Create"
    And I should see "Butterfly"
    And I should see "Technically known as a double underhook"
    And I should see "Wolf"
    When I follow "Active"
    And I should not see "Butterfly"
    And I should not see "Technically known as a double underhook"
    And I should not see "Wolf"

  @javascript
  Scenario: Edit a project (name, description and worker group)
    Given I have the following projects
      | name        | client     | status   | description                                               |
      | Giant Swing | Mr. Kenedy | active   | Takes hold of a supine opponent's legs and pivots rapidly |
    And I am a member of the following worker groups
      | name  |
      | Bear  |
      | Tiger |
      | Wolf  |
    Then I am on the project list page
    And I follow "Edit"
    And I fill in "Name" with "Crucifix"
    And I fill in "Description" with "Place the opponent in a gutwrench waistlock"
    And I select "Bear" from "Worker Group"
    And I press "Update"
    And I should see "Crucifix"
    And I should see "Place the opponent in a gutwrench waistlock"
    And I should see "Bear"


  @javascript
  Scenario: Deactivate a project
    Given I have the following projects
      | name        | client     | status   | description                                               |
      | Giant Swing | Mr. Kenedy | active   | Takes hold of a supine opponent's legs and pivots rapidly |
    Then I am on the project list page
    And I follow "Edit"
    And I uncheck "project[status]" within "#facebox"
    And I press "Update"
    And I should not see "Giant Swing"
    And I should not see "Takes hold of a supine opponent's legs and pivots rapidly"
    When I follow "Inactive"
    Then I should see "Giant Swing"
    And I should see "Takes hold of a supine opponent's legs and pivots rapidly"

  @javascript
  Scenario: Activate a project
    Given I have the following projects
      | name        | client     | status   | description                                               |
      | Giant Swing | Mr. Kenedy | Inactive | Takes hold of a supine opponent's legs and pivots rapidly |

    Then I am on the project list page
    And I follow "Inactive"
    And I follow "Edit"
    And I check "project[status]" within "#facebox"
    And I press "Update"
    And I should not see "Giant Swing"
    And I should not see "Takes hold of a supine opponent's legs and pivots rapidly"
    And I follow "Active"
    And I should see "Giant Swing"
    And I should see "Takes hold of a supine opponent's legs and pivots rapidly"

Feature: Managers manage tasks
  In order to manage tasks for my projects
  As a manager
  I should be able to create, view, edit and delete tasks

  Background:
    Given I am logged in as a manager
    And I am on the task list page

  Scenario: Navigate by project name
    Given I have the following projects:
      | project           | client                |
      | Chrome            | Google, Inc.          |
      | Firefox           | Mozilla Foundation    |
      | Internet Explorer | Microsoft Corporation |
    When I go to the task list page
    Then I should see the following project:
      | project           |
      | Chrome            |
      | Firefox           |
      | Internet Explorer |

  Scenario: View tasks by project
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following tasks:
      | title                    | status   |
      | Upgrade to Rails 2.3.3   | OPEN     |
      | Update outdated gems     | COMPLETE |
      | Describe worker features | VERIFIED |
    When I go to the all tasks page
      And I follow "ten"
    Then I should see the following
      | title |
      | Upgrade to Rails 2.3.3   |
      | Update outdated gems     |
      | Describe worker features |

  Scenario: View tasks by status
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following tasks:
      | title                               | status   |
      | Describe client features            | open     |
      | Upgrade to Rails 2.3.3              | complete |
      | Update outdated gems                | complete |
      | Describe worker features            | verified |
      | Clean out 10 database               | verified |
      | Rename Requirement to ClientRequest | verified |
    When I go to the all tasks page
     And I follow "ten"
    Then I should see the following tasks
      | title                               |
      | Describe client features            |
      | Upgrade to Rails 2.3.3              |
      | Update outdated gems                |
      | Describe worker features            |
      | Clean out 10 database               |
      | Rename Requirement to ClientRequest |
    When I go to the all tasks page
    And I follow "unassigned"
    Then I should see the following
      | title                               |
      | Describe client features            |
    When I follow "completed"
    Then I should see the following
      | title                               |
      | Upgrade to Rails 2.3.3              |
      | Update outdated gems                |
    When I follow "archived"
    Then I should see the following
      | title                               |
      | Describe worker features            |
      | Clean out 10 database               |
      | Rename Requirement to ClientRequest |

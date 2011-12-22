Feature: Leaders manage timesheets
  In order to manage timesheets for my projects
  As a leader
  I should be able to view timesheets by worker and by project

  Background:
    Given I am logged in as a leader
    And I am on the timesheet list page


  Scenario: Navigate by project
    Given I have the following projects:
      | project           | client                |
      | Chrome            | Google, Inc.          |
      | Firefox           | Mozilla Foundation    |
      | Internet Explorer | Microsoft Corporation |  
  When I go to the timesheet list page
    Then I should see the following
      | project           |
      | Chrome            |
      | Firefox           |
      | Internet Explorer |


  Scenario: View timesheets by project
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following timesheet entries:
      | task                     | hours |
      | Upgrade to Rails 2.3.3   | 4     |
      | Update outdated gems     | 2     |
      | Describe worker features | 8     |
    When I go to the timesheet list page       
    And I follow "ten"
    Then I should see the following task:
      | task                     |
      | Upgrade to Rails 2.3.3   |
      | Update outdated gems     |
      | Describe worker features |


  Scenario: Navigate by worker
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following workers:
      | login |
      | hoa   |
      | lam   |       
    When I go to the timesheet list worker
    Then I should see the following login:
      | login |
      | hoa   |
      | lam   | 
    

  Scenario: View timesheets by worker
    Given I have the project "ten" with the client "Endax"
    And the worker "david" is a member of the project "ten"
    And the worker "david" has created the following timesheet entries:
      | task                     | hours |
      | Upgrade to Rails 2.3.3   | 4     |
      | Update outdated gems     | 2     |
      | Describe worker features | 8     |
    When I go to the timesheet list worker
    And I follow "david"
    Then I should see the following task:
      | task                     |
      | Upgrade to Rails 2.3.3   |
      | Update outdated gems     |
      | Describe worker features |

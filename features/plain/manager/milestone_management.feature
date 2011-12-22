#NO NEED TO IMPLEMENT NOW - LATER ITERATION
Feature: Managers manage milestones
  In order to manage milestones for my projects
  As a manager
  I should be able to create, view, edit and delete milestones

  Background:
    Given I am logged in as a manager

#  Scenario Outline: Navigate by project name
#    Given I have the project "<project>" with the client "<client>"
#    When I go to the the milestones page
#    Then I should see "<project>" on the menu bar
#
#    Examples:
#      | project           | client                |
#      | Chrome            | Google, Inc.          |
#      | Firefox           | Mozilla Foundation    |
#      | Internet Explorer | Microsoft Corporation |

  Scenario: View milestones of a project
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following milestones
      | title                    | due_date   |
      | Business Analysis        | 2009-07-31 |
      | Prototyping              | 2009-08-31 |
      | Graphics and HTML Design | 2009-09-31 |
    When I go to the the milestones page
    Then I should see the following date
      | date   |
      | 31 JUL |
      | 31 AUG |
      | 31 SEP |

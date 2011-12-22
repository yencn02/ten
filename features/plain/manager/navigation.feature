Feature: Manager Navigation
  As a manager
  I want to be able to manage: projects, messages, milestones, requests, tasks, timesheets

  Background: 
    Given I am logged in as a manager

  Scenario: Show the "Project" menu item
    Then I should see the "Project" menu item
  Scenario: Show the "Message" menu item
    Then I should see the "Message" menu item
#  Scenario: Show the "Milestone" menu item
#    Then I should see the "Milestone" menu item
  Scenario: Show the "Client Request" menu item
    Then I should see the "Requirement" menu item
  Scenario: Show the "Task" menu item
    Then I should see the "Task" menu item
  Scenario: Show the "Time" menu item
    Then I should see the "Time" menu item

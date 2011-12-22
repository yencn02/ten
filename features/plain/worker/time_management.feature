Feature: managing time sheet entries as a worker
  In order to manage time for a series of tasks
  As a worker 
  I want be able to add time to a particular task in order to track my time working on tasks

  Background:
    Given I am logged in as a worker
    And I already have a task called "Test Task A" that has "0" hours completed of "10" hours estimated
    And I am on the all tasks page

  Scenario: view the time entry panel
    And I click on the time icon for "Test Task A"
    Then I should see the time panel drop down

  @javascript
  Scenario: enter time sheet info for a specific task
    When I click on the time icon for "Test Task A"
    And I fill in the description of "Test Task A" with "This is a test comment"
    And I fill in the billed hour of "Test Task A" with "5"
    And I press "Save"
    Then I wait for response about "1" seconds
    And I should see that the project image is "50" percent complete

  @javascript
  Scenario: enter time sheet info for a specific completed task
    When I click on the time icon for "Test Task A"
    And I fill in the description of "Test Task A" with "This is a test comment to complete the task"
    And I fill in the billed hour of "Test Task A" with "10"
    And I press "Save"
    Then I wait for response about "1" seconds
    And I should not see the time icon for "Test Task A"
    And I should see that the project image is "100" percent complete

  @javascript
  Scenario: ensure that updated time sheet info is reflected in the task view
    When I click on the time icon for "Test Task A"
    And I fill in the description of "Test Task A" with "This is a test comment to complete the task"
    And I fill in the billed hour of "Test Task A" with "5"
    And I press "Save"
    Then I wait for response about "1" seconds
    Then I follow "Test Task A"
    And I should see that the completed hours is "5.0" of "10.0" estimated

  @javascript @top
  Scenario: Require git hash when selecting complete Edit 
    When I click on the time icon for "Test Task A"
    And I fill in the description of "Test Task A" with "This is a test comment to complete the task"
    And I fill in the billed hour of "Test Task A" with "5"
    And I check "Completed"
    And I should see "Commit Hash"
    And I fill in commit hash of "Test Task A" with "1b5686d07db9f99df9042f0a50104a23c32f3f08"
    And I press "Save"
    And I am on the all tasks page
    Then I should not see "Clock icon"
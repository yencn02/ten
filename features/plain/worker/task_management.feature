Feature: Workers manage tasks
  In order to manage tasks for projects
  As a worker
  I should be able to view tasks by project and status

  Background:
    Given I am logged in as a worker
    And I am assigned to a complete project called "Project X"
    And I am on the all tasks page
  
  Scenario Outline: view all tasks for a specific project and status
    When I click on the <project> project
    When I click on the <status> status
    Then I should see all <status> for <project>

    Examples:
      | project   | status      |
      | Project X | unassigned  |
      | Project X | assigned  |
      | Project X | completed   |
      | Project X | archived    |
      | Project X | all         |

  Scenario: should be able to view a task
    When I click on the "Test Task A" link
    Then I should see the task show view for "Test Task A"

  Scenario: should be able to view the changes
    When I click on the "Test Task A" link
    Then I should see at least one change record

  Scenario: should be not able to add a change because I am a worker
    When I click on the "Test Task A" link
    Then I should not be able to add a new change

  Scenario: should be able to view the client discussion
    When I click on the "Test Task A" link
    Then I should see at least one client discussion message


 Scenario: should be able to add a technical note
    When I click on the "Test Task A" link
    And I add a technical note "this is a test"
    Then I should be able to see the technical note "this is a test"

  @javascript
  Scenario: should be able to add a message
    When I click on the "Test Task A" link
    And I add the message "This is a test"
    Then I should be able to see the message "This is a test"

  Scenario: should be able to reply to a message
    When I click on the "Test Task A" link
    And I reply to the "This is a test" message with "This is another test"
    Then I should be able to see the message "This is another test"

@focus
  @javascript
  Scenario: should be able to delete a message
    When I click on the "Test Task A" link
    And I add the message "This is a test"
    And I delete the message "This is a test"
    Then I should not see the message "This is a test"


  Scenario: apply for unassigned task
    Given my project has unassigned task with the title of "Implement a  search engine"
    And I am on the all tasks page
    When I follow "Volunteer" on "Implement a  search engine"
    When I fill in "Estimated hours" with "40"
    And I fill in "Start date" with "08/09/2009"
    And I fill in "Due date" with "08/12/2009"
    And I press "Volunteer"
    Then I should see "Implement a search engine"
    And I should see the task assigned to me with "40.0" hours of estimated


  Scenario: save message for developer discussion
    When I click on the "Test Task A" link
    Then I should see the task show view for "Test Task A"
    And I fill in "message_body" for this task a message with "Hello everyone"
    And I should see "Hello everyone"

  @javascript
  Scenario: should be able to attached a new file
    When I click on the "Test Task A" link
    And I add a "/test/fixtures/mockup.pdf" file attachment
    Then I should see the "mockup.pdf" attached file


  @javascript
  Scenario Outline: toggle all the show / hide panels
    When I click on the "Test Task A" link
    And I click on the "<action>" link for "<section>"
    Then I should not see the "<section>" section
    And I click on the "<action>" link for "<section>"
    Then I should see the "<section>" section

    Examples:
      | action | section              | not |
      | Hide   | Changes              | not |
      | Hide   | Client Discussion    | not |
      | Hide   | Technical Notes      | not |
      | Hide   | Developer Discussion | not |
      | Show   | Changes              |     |
      | Show   | Client Discussion    |     |
      | Show   | Technical Notes      |     |
      | Show   | Developer Discussion |     |

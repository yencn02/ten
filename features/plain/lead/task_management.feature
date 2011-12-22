Feature: Leaders manage tasks
  In order to manage tasks for my projects
  As a leader
  I should be able to create, view, edit and delete tasks

  Background:
    Given I am logged in as a leader
    And I am on the all tasks page

  Scenario: Navigate by project name
    Given I have the following projects:
      | project           | client                |
      | Chrome            | Google, Inc.          |
      | Firefox           | Mozilla Foundation    |
      | Internet Explorer | Microsoft Corporation |
    When I go to the all tasks page
    Then I should see the following projects:
      | project           |
      | Chrome            |
      | Firefox           |
      | Internet Explorer |

  Scenario: View tasks by project
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following tasks:
      | title                    | status         |
      | Upgrade to Rails 2.3.3   | unassigned     |
      | Update outdated gems     | completed      |
      | Describe worker features | archived       |
    When I go to the all tasks page
    And I follow "ten"
    Then I should see the following tasks:
      | title                    |
      | Upgrade to Rails 2.3.3   |
      | Update outdated gems     |
      | Describe worker features |

  Scenario: View tasks by status
    Given I have the project "ten" with the client "Endax"
    And the project "ten" includes the following tasks:
      | title                               | status      |
      | Describe client features            | unassigned  |
      | Upgrade to Rails 2.3.3              | completed   |
      | Update outdated gems                | completed   |
      | Describe worker features            | archived    |
      | Clean out 10 database               | archived    |
      | Rename Requirement to ClientRequest | archived    |
    When I go to the all tasks page
    When I follow "ten"
    Then I should see the following tasks:
      | title                               |
      | Describe client features            |
      | Upgrade to Rails 2.3.3              |
      | Update outdated gems                |
      | Describe worker features            |
      | Clean out 10 database               |
      | Rename Requirement to ClientRequest |
    When I follow "unassigned"
    Then I should see the following tasks:
      | title                    |
      | Describe client features |
    When I follow "completed"
    Then I should see the following tasks:
      | title                  |
      | Upgrade to Rails 2.3.3 |
      | Update outdated gems   |
    When I follow "archived"
    Then I should see the following tasks:
      | title                               |
      | Describe worker features            |
      | Clean out 10 database               |
      | Rename Requirement to ClientRequest |


  Scenario: View a task
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone    | created_at | description                                |
      | Need search engine | Extreme  | started | November 1st | 11/11/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20.0      | 11/28/2009 | Stan   |
    When I go to the task view page of "Implement a search engine"
    Then I should see "Implement a search engine"
    And I should see "Nov 11"
    And I should see "Need to incorporate a global search engine"
    And I should see "Extreme"
    And I should see "assigned"
    And I should see "0.0 hour(s)"
    And I should see "November 1st"
    And I should see "Stan"


@javascript
  Scenario: Estimate and Assign un assigned task
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status | milestone    | created_at | description                                |
      | Need search engine | Extreme  | new    | November 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following unassigned tasks:
      | title                     |
      | Implement a search engine |
    When I go to the all tasks page
    And I follow "ten"
    And I follow "Unassigned" on "Implement a search engine" task
    Then I should see "Implement a search engine"
    Given the project "ten" includes the following workers:
      | login |
      | Joe   |
      | Stan  |
      | Bill  |
    When I fill in "Estimated hours" with "40"
    And I fill in "Start date" with "08-09-2011"
    And I fill in "Due date" with "08-12-2011"
    And I press "Next"
    Then I should see "Need search engine"
    And I should see "Need to incorporate a global search engine"
    And I should see the following workers:
      | login |
      | Joe   |
      | Stan  |
      | Bill  |
    Given the worker "Bill" has the least assigned hours among other workers
    When I follow "Bill"
    And I press "Assign"
    Then I should see "Need search engine" in the task list of the worker "Bill"


@javascript
  Scenario: Edit a task
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone    | created_at | description                                |
      | Need search engine | Extreme  | started | November 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the project "ten" includes the following workers:
      | login |
      | Joe   |
      | Stan  |
      | Bill  |
      | Jim   |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | start_date | due_date   | worker |
      | Implement a search engine | 20.0      | 11/20/2009 | 11/28/2009 | Stan   |
    When I go to the task view page of "Implement a search engine"
    And I follow "Edit"
    And I fill in "Title" with "Implement a global search engine"
    And I fill in "Estimated hours" with "40.0"
    And I fill in "Start date" with "22-3-2011"
    And I fill in "Due date" with "30-3-2011"
    And I choose "Jim"
    And I press "Save" on "taskEditPanel" panel
    Then I should see "Implement a global search engine"
    And I should see "40.0 hour(s)"
    And I should see "Jim"
    And I should see "Mar-30-2011"

  Scenario: View changes
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the client request "Need search engine" includes the following changes:
      | description                               | created_at |
      | Do search on messages, projects and notes | 11/18/2008 |
      | Just for projects and notes, not messages | 11/19/2008 |
      | Show search results by relevance          | 11/23/2008 |
    When I go to the task view page of "Implement a search engine"
    Then I should see the following changes:
      | description                               | created_at |
      | Do search on messages, projects and notes | 11/18/2008 |
      | Just for projects and notes, not messages | 11/19/2008 |
      | Show search results by relevance          | 11/23/2008 |

  Scenario: View technical notes
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status      | milestone   | created_at | description                                |
      | Need search engine | Extreme  | In progress | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the task "Implement a search engine" includes the following technical notes:
      | description                                   | created_at |
      | Let's use Thinking Sphinx for this            | 11/21/2010 |
      | Check out the relevance calculation algorithm | 11/22/2010 |
    When I go to the task view page of "Implement a search engine"
    Then I should see the following technical notes:
      | description                                   |
      | Let's use Thinking Sphinx for this            |
      | Check out the relevance calculation algorithm |


  Scenario: Create a technical note
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    When I go to the task view page of "Implement a search engine"
    And I follow "New" within "#technical-notes"
    And I fill in "Description" with "Let's use Thinking Sphinx for this" within "#technical-notes"
    And I press "Create" within "#technical-notes"
    Then I should see "Let's use Thinking Sphinx for this"

@javascript
  Scenario: Edit a technical note
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the task "Implement a search engine" includes the following technical notes:
      | description                       | created_at |
      | Let's use Thinking Sphin for this | 11/21/2009 |
    When I go to the task view page of "Implement a search engine"
    And I click the text "Let's use Thinking Sphin for this" of the note
    And I change text "Let's use Thinking Sphin for this" to "change note"
    And I press "Save" within "#technical-notes"
    Then I should see "change note"

  Scenario: Delete a technical note
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the task "Implement a search engine" includes the following technical notes:
      | description                        | created_at |
      | Let's use Thinking Sphinx for this | 11/21/2008 |
    When I go to the task view page of "Implement a search engine"
    And I follow "Delete" to remove "Let's use Thinking Sphinx for this" on "notes" panel
    Then I should not see "Let's use Thinking Sphinx for this"


  Scenario: View files
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the task "Implement a search engine" includes the following files:
      | filename   | description                        | created_at | content_type | size |
      | issue.png  | Screenshot of the issue I'm having | 11/19/2008 | img/png      | 1234 |
      | sphinx.yml | A recommended Sphinx configuration | 11/25/2008 | text/xml     | 123  |
    When I go to the task view page of "Implement a search engine"
    Then I should see the following files:
      | filename   | description                        |
      | issue.png  | Screenshot of the issue I'm having |
      | sphinx.yml | A recommended Sphinx configuration |


@javascript
  Scenario: Add a file
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    When I go to the task view page of "Implement a search engine"
    And I follow "New" on "fileList__task" panel
    And I fill in note with "Screenshot of the issue I am having" for "task" on "fileList__task" panel
    And I attach the file at "/test/fixtures/mockup.pdf" to "attachedFile__task[file]" on "newFile__task" panel
    And I press "Create" on "newFile__task" panel
    Then I should see "mockup.pdf"
    And I should see "Screenshot of the issue I am having"

  Scenario: Delete a file
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the task "Implement a search engine" includes the following files:
      | filename  | description                        | created_at | content_type | size |
      | issue.png | Screenshot of the issue I'm having | 11/19/2008 | img/png      | 1234 |
    When I go to the task view page of "Implement a search engine"
    And I follow "Delete" to remove "issue.png" on "files__task" panel
    Then I should not see "Screenshot of the issue I'm having"

  @javascript
  Scenario: Edit a file note
    Given I am a member of the project "ten"
    And the project "ten" includes the following client requests:
      | title              | priority | status  | milestone   | created_at | description                                |
      | Need search engine | Extreme  | started | January 1st | 11/17/2008 | Need to incorporate a global search engine |
    And the client request "Need search engine" includes the following tasks:
      | title                     | estimated | due_date   | worker |
      | Implement a search engine | 20        | 11/28/2009 | Stan   |
    And the task "Implement a search engine" includes the following files:
      | filename  | description | created_at | content_type | size |
      | issue.png | Screenshot  | 11/19/2008 | img/png      | 1234 |
    When I go to the task view page of "Implement a search engine"
    And I click on "Screenshot" on "files_task" panel
    And I change note "Screenshot" to "Screenshot of the issue I am having"
    And I press "Save" within "#fileList__task"
    Then I should see "Screenshot of the issue I am having"


@javascript
    Scenario: Create a task
      Given I am a member of the project "ten"
      And project "ten" has at least one milestone
      When I go to the task view of the project "ten"
      And I follow "New"
      And I fill in "Title" with "Need search engine"
      And I fill in the "client_request_description" with "Need to incorporate a global search engine"
      When I press "Request"
      Then I should see "Need search engine"
      And I should see "Need to incorporate a global search engine"
      Given the project "ten" includes the following workers:
        | login |
        | Joe   |
        | Stan  |
        | Bill  |
      When I fill in "Estimated hours" with "40"
      And I fill in "Start date" with "08-09-2011"
      And I fill in "Due date" with "08-12-2011"
      #And I fill in "Implementation notes" with "Let's use Thinking Sphinx for this"
      And I press "Next"
      Then I should see "Need search engine"
      And I should see "Need to incorporate a global search engine"
      And I should see the following workers:
        | login |
        | Joe   |
        | Stan  |
        | Bill  |

      Given the worker "Bill" has the least assigned hours among other workers
      When I follow "Bill"
      And I press "Assign"
      Then I should see "Need search engine" in the task list of the worker "Bill"


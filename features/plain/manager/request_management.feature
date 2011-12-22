Feature: Managers manage client requests
  In order to manage client requests for my projects
  As a manager
  I should be able to create, view, edit and delete client requests

  Background:
    Given I am logged in as a manager    
    Scenario: View a client request
      Given I have the following client requests:
        | title              | priority | status | milestone  | created_at | description                                |
        | Need search engine | Extreme  | New    | January 20 | 01/15/1999 | Need to incorporate a global search engine |
      When I go to show request page for "Need search engine"
      Then I should see "Need search engine"
      And I should see "Jan 15"
      And I should see "Extreme"
      And I should see "New"
      And I should see "January 20"
      And I should see "Need to incorporate a global search engine"

    @javascript
    Scenario: Create a client request
      Given I am a member of the project "ten"
      And project "ten" has at least one milestone
      And the project "ten" includes the following workers:
        | login |
        | Joe   |
        | Stan  |
        | Bill  |
      When I go to the task view of the project "ten"
      And I follow "New"
      And I fill in "Title" with "Need search engine"
      And I fill in the "client_request_description" with "Need to incorporate a global search engine"
      When I press "Request"
      Then I should see "Need search engine"
      And I should see "Need to incorporate a global search engine"      
      When I fill in "Estimated hours" with "40"
      And I fill in "Start date" with "12-08-2011"
      And I fill in "Due date" with "12-08-2011"
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

@javacript
    Scenario: View changes
      Given I have a client request with a title of "Need search engine"
      And the client request "Need search engine" includes the following changes:
        | description                               | created_at  |
        | Do search on messages, projects and notes | 01/17/2009  |
        | Just for projects and notes, not messages | 01/20/2009  |
        | Show search results by relevance          | 01/22/2009  |
      When I go to the show request page for "Need search engine"
      Then I should see the following changes:
        | description                               | created_at  |
        | Do search on messages, projects and notes | 01/17/2009  |
        | Just for projects and notes, not messages | 01/20/2009  |
        | Show search results by relevance          | 01/22/2009  |

    @javascript
    Scenario: Create a change
      Given I have a client request with a title of "Need search engine"
      When I go to the show request page for "Need search engine"
      And I follow "New" on "changes" panel
      And I fill in the description with "Show search results by relevance" for a change of "client request"
      And I press "Save" on "changes" panel
      Then I should see "Show search results by relevance"

    @javascript
    Scenario: Edit a change
      Given I have a client request with a title of "Need search engine"
      And the client request "Need search engine" includes the change "Show search results by relevance"
      When I go to to show request page for "Need search engine"
      And I click the text "Show search results by relevance" of the change
      And I change the text "Show search results by relevance" of the change to "Show search results by relevance then by date"
      And I press "Save" within "#changes"
      Then I should see "Show search results by relevance then by date"
    
    @javascript
    Scenario: Delete a change
      Given I have a client request with a title of "Need search engine"
      And the client request "Need search engine" includes the change "Show search results by relevance"
      When I go to the show request page for "Need search engine"
      And I click the "Delete" link to delete
      Then I should not see "Show search results by relevance"

    Scenario: View files
      Given I have a client request with a title of "Need search engine"
      And the client request "Need search engine" includes the following files:
        | filename                  | description                                                          |
        | rough_mockup.png          | Here's a rough mockup of how it will incorporate into the main page. |
        | mockup_updated.png        | Actually this one is better.                                         |
        | relevance-calculation.doc | An algorithm for determining relevance values of search results      |
      When I go to show request page for "Need search engine"
      Then I should see the following files on the change files panel:
        | filename                  | description                                                          |
        | rough_mockup.png          | Here's a rough mockup of how it will incorporate into the main page. |
        | mockup_updated.png        | Actually this one is better.                                         |
        | relevance-calculation.doc | An algorithm for determining relevance values of search results      |

    @javascript
    Scenario: Add a file
      Given I have a client request with a title of "Need search engine"
      When I go to show request page for "Need search engine"
      And I follow "New" within "#files"
      And I fill in the note with "Here is a rough mockup of how it will incorporate into the main page." of attached file for "client request"
      And I attach the file at "/test/fixtures/mockup.pdf" to "attachedFile__client_request[file]"
      And I press "Save" within "#files"
      Then I should see "mockup.pdf"
      And I should see "Here is a rough mockup of how it will incorporate into the main page."

    @javascript
    Scenario: Edit the description of a file
      Given I have a client request with a title of "Need search engine"
      And the client request "Need search engine" includes the file "mockup.pdf" which description is "Actually this one is better."
      When I go to show request page for "Need search engine"
      And I click the text "Actually this one is better." of the attached file
      And I change the text "Actually this one is better." of the attached file to "An updated version of the inital rough mockup"
      And I press "Save" within "#files"
      Then I should see "An updated version of the inital rough mockup"

    @javascript
    Scenario: Delete a file
      Given I have a client request with a title of "Need search engine"
      And the client request "Need search engine" includes the file "mockup.pdf" which description is "Actually this one is better."
      When I go to show request page for "Need search engine"
      And I click the "Delete" link to delete
      Then I should not see "Actually this one is better."
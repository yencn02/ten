Feature: managing messages as a worker account
  In order to manage messages for all projects and one specified project
  As a worker 
  I want be able to view all most recent messages on my projects

  Background: 
    Given I am logged in as a worker
    And I am a member of the project "ten"
    And project "ten" has a client request and associated task
    And I have the following messages:
        | title                               | status   |
        | How does RedBox work?               | unread   |
        | Check out RedBox documentation      | read     |
        | How does RedBox documentation work? | archived |

    And I have following client messages:
        | title                               | status   |
        | Should return top 10 best result?   | unread	 |
        | And works as fast as Google         | read     |
        | And not works as slow as Yahoo      | archived |
 
    And I am on the all messages page

  Scenario: view all messages related to my group's tasks
    Then I should see the following messages:
        | title                               | status | font   |
        | How does RedBox work?               | unread | bold   |
        | Check out RedBox documentation      | read   | normal |
        | Should return top 10 best result?   | unread | bold   |
        | And works as fast as Google         | read   | normal |
    And I should not see the following messages:
        | title                               | status   | font   |
        | How does RedBox documentation work? | archived | normal |
        | And not works as slow as Yahoo      | archived | normal |

    

    Scenario: View message by status
   
   When I am on the read messages page
    Then I should see the following messages:
        | title                               | status   | font   |
        | Check out RedBox documentation      | read     | normal |
        | And works as fast as Google         | read     | normal |
    And I should not see the following messages:
        | title                               | status   | font   |
        | How does RedBox work?               | unread   | bold   |
        | Should return top 10 best result?   | unread   | bold   |
        | How does RedBox documentation work? | archived | normal |
        | And not works as slow as Yahoo      | archived | normal |
   
   When I follow "unread"
    Then I should see the following messages:
        | title                               | status   | font   |
        | How does RedBox work?               | unread   | bold   |
        | Should return top 10 best result?   | unread   | bold   |
    And I should not see the following messages:
        | title                               | status   | font   |
        | Check out RedBox documentation      | read     | normal |
        | How does RedBox documentation work? | archived | normal |
        | And works as fast as Google         | read     | normal |
        | And not works as slow as Yahoo      | archived | normal |
   
   When I follow "archive"
    Then I should see the following messages:
        | title                               | status   | font   | 
        | How does RedBox documentation work? | archived | normal |
        | And not works as slow as Yahoo      | archived | normal |
    And I should not see the following messages:
        | title                               | status   | font   |
        | How does RedBox work?               | unread   | bold   |
        | Should return top 10 best result?   | unread   | bold   |
        | Check out RedBox documentation      | read     | normal |
        | And works as fast as Google         | read     | normal |
    
  Scenario: link to task from message
    When I follow "How does RedBox work?"
    Then I should go to the task show page that "How does RedBox work?" message belongs to
        
    
  #  Scenario Outline: Set messages as unread
  # When I check on the message "Check out RedBox documentation" 
  # And I press "unread"
  #  Then I should see "Check out RedBox documentation" message in normal font

 # Scenario Outline: Set messages as archived
  #  When I select "How does RedBox work?" message
  # And I press "Archive"
   # Then I should not see "How does RedBox work?"
 
   #Scenario: link to task from client message
   #When I follow "Should return top 10 best result?"
   #Then I should go to the task edit page that "Should return top 10 best result?" client message belongs to
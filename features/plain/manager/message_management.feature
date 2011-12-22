Feature: Managers manage messages
  In order to manage messages for my projects
  As a manager
  I should be able to create, view, edit and delete messages

  Background:
    Given I am logged in as a manager
    And I am on the all messages page


  Scenario Outline: View all messages
    Given I have a message with a title of <title>
    When I go to the all messages page
    Then I should see "<title>"

    Examples:
      | title               | 
      | Cucumber Rocks      | 
      | RSpec or shoulda    | 
      | webrat and Selenium | 

  Scenario: View messages by status
    Given I have the following messages
      | status   | title                                     |
      | UNREAD   | Rails 2.3.3 Released                      |
      | UNREAD   | Your Music Update                         |
      | READ     | Review: Sony Blue-ray Home Theater System |
      | ARCHIVED | Top Ajax Challenges                       |
      | ARCHIVED | EditorAtLarge Sign-Up Confirmation        |
    When I am on the unread messages page
    Then I should see the following messages:
      | status   | title                                     |
      | UNREAD   | Rails 2.3.3 Released                      |
      | UNREAD   | Your Music Update                         |
    
    When I am on the read messages page
    Then I should see the following messages:
      | status   | title                                     |
      | READ     | Review: Sony Blue-ray Home Theater System |
    
    When I am on the archived messages page
    Then I should see the following messages:
      | status   | title                                     |
      | ARCHIVED | Top Ajax Challenges                       |
      | ARCHIVED | EditorAtLarge Sign-Up Confirmation        |    


 #Scenario: Post a message
 #    Given I have the project "Ogg Theora"
 #   When I go to the new message page
 #    And I fill in "Title" with "Ruby is a dynamic programming language"
 #     And I fill in "Content" on new message form with
 #       """
 #       Ruby is a dynamic programming language with a complex but expressive grammar and a core
 #       class library with a rich and powerful API. Ruby draws inspiration from Lisp, Smalltalk,
 #       and Perl, but uses a grammar that is easy for C and Java programmers to learn.
 #       """
 #    And I press "Post"
 #    Then I should see "Ruby is a dynamic programming language"
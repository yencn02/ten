Feature: Managers manage messages discussing a client request
  In order to manage messages discussing a client request
  As a manager
  I should be able to view, post, reply and delete messages

  Background:
    Given I am logged in as a manager    
    Scenario: View messages
      Given I have a client request with a title of "Uncrop photos in lightboxes"
      And the client request "Uncrop photos in lightboxes" includes the following messages:
        | sender    | body                                | sent_at    |
        | George    | How does RedBox work?               | 11/17/2004 |
        | Ashlee    | Check out RedBox documentation      | 11/18/2004 |
        | George    | How does RedBox documentation work? | 12/01/2004 |         
      When I am on show request page for "Uncrop photos in lightboxes"
      Then I should see the following client request messages:
        | sender    | body                                |
        | George    | How does RedBox work?               |
        | Ashlee    | Check out RedBox documentation      |
        | George    | How does RedBox documentation work? |

    @javascript
    Scenario: View a message
      Given I have a client request with a title of "Parallel computing research"
      And the client request "Parallel computing research" include the message
        """
        Parallelism has been employed for many years, mainly in high-performance computing, but
        interest in it has grown lately due to the physical constraints preventing frequency scaling.
        """
      When I go to the show request page for "Parallel computing research"
      And I click on "Parallelism has been employed" to view full message
      Then I should see
        """
        Parallelism has been employed for many years, mainly in high-performance computing, but interest in it has grown lately due to the physical constraints preventing frequency scaling.
        """

    
    @javascript
    Scenario: Post a message
      Given I have a client request with a title of "The Ruby programming language"
      And no messages have been posted discussing the client request "The Ruby programming language"
      When I am on show request page for "The Ruby programming language"
      And I click a link "client-discussion-link"
      And I fill in Content on new message form
        """
        Ruby is a dynamic programming language with a complex but expressive grammar and a core class library with a rich and powerful API. 
        """
     And I press "Create"
     Then I should see
        """
        Ruby is a dynamic programming language
        """

    @javascript
    Scenario: Reply a message
      Given I have a client request with a title of "The Ruby programming language"
      And the client request "The Ruby programming language" include the message
        """
        Ruby is a dynamic programming language with a complex but expressive grammar and a core
        class library with a rich and powerful API. Ruby draws inspiration from Lisp, Smalltalk,
        and Perl, but uses a grammar that is easy for C and Java programmers to learn.
        """
      When I am on show request page for "The Ruby programming language"
      And I click on "Ruby is a dynamic programming language" to view full message
      And I follow "Reply"
      And I fill in "Content" on reply form with "It was written by an all-star team."
      And I press "Create"
      Then I should see "It was written by an all-star team."

    @javascript
    Scenario: Delete a message
      Given I have a client request with a title of "The Ruby programming language"
      And To discuss the client request "The Ruby programming language" I posted the message
        """
        Ruby is a dynamic programming language with a complex but expressive grammar and a core class library with a rich and powerful API
        """
      When I am on show request page for "The Ruby programming language"
      And I click on "Ruby is a dynamic programming language" to view full message
      And I follow "delete" to remove the message
      Then I should not see "Ruby is a dynamic programming language"

    @javascript
    Scenario: Delete a message posted by someone else
      Given I have a client request with a title of "The Ruby programming language"
      And the client request "The Ruby programming language" include the message
        """
        Ruby is a dynamic programming language with a complex but expressive grammar and a core
        class library with a rich and powerful API. Ruby draws inspiration from Lisp, Smalltalk,
        and Perl, but uses a grammar that is easy for C and Java programmers to learn.
        """
      When I am on show request page for "The Ruby programming language"
      And I click on "Ruby is a dynamic programming language" to view full message
      And I follow "delete" to remove the message
      Then I should not see "Ruby is a dynamic programming language"

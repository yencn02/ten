Feature: managing messages as a client account
  In order to manage messages for my projects
  As a client
  I should be be able to create, read, reply and archive messages

  Background:
    Given I am logged in as a client
    And I am on the client message list page


  Scenario: Show all messages
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |      
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |  
      
      
    When I go to the client message list page
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |


@javascript
  Scenario: Show messages by status
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |
    When I follow "read"
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |

    When I follow "unread"
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |

    When I follow "archive"
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |

  Scenario: Mark selected messages as read
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
    When I am on the client message list page
    And I check on the message "Passing out in a submission hold constitutes a loss"
    And I check on the message "Strike an opponent with a foreign object"
    And I press "Read"
    Then the following client messages should not be shown in bold
      | project | request          | sender | status   | message                                             |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
    When I press "Read"
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Submission       | ENDAX  | READ     | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | READ     | Strike an opponent with a foreign object            |

  
  Scenario: Archive selected messages
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
    When I am on the client message list page
    And I check on the message "Pin both the opponent's shoulders against the mat"
    And I check on the message "Double countouts are possible"
    And I press "Archive"    
    When I press "Archive"
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |

  Scenario: Show unread messages in bold
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |
    When I go to the client message list page
    Then the following client messages should be shown in bold
      | project | request          | sender | status   | message                                             |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |



  @javascript
  Scenario: Mark all messages as read
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |
    And I am on the client message list page
    When I check "all"
    And I press "Read"
    Then the following client messages should not be shown in bold
      | project | request          | sender | status | message                                             |
      | ECW     | Submission       | ENDAX  | UNREAD | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD | Strike an opponent with a foreign object            |
    When I press "read"
    Then I should see the following client messages
      | project | request          | sender | status | message                                             |
      | ECW     | Pinfall          | me     | READ   | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ   | Double countouts are possible                       |
      | ECW     | Submission       | ENDAX  | READ   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | READ   | Strike an opponent with a foreign object            |
    
    
  @javascript
  Scenario: Archive all messages
    Given I have the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |
    And I am on the client message list page
    When I check "all"
    And I press "Archive"
    Then I should see "The selected messages have been updated status"
    # When unread messages are archived, they should no longer be shown in bold
    And the following client messages should not be shown in bold
      | project | request          | sender | status | message                                             |
      | ECW     | Submission       | ENDAX  | UNREAD | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD | Strike an opponent with a foreign object            |
    When I press "Archive"
    Then I should see the following client messages
      | project | request          | sender | status   | message                                             |
      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |

#Scenario: Search for messages
#    Given I have the following client messages
#      | project | request          | sender | status   | message                                             |
#      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
#      | ECW     | Submission       | ENDAX  | UNREAD   | Passing out in a submission hold constitutes a loss |
#      | ECW     | Submission       | me     | ARCHIVED | Those are famous for winning matches via submission |
#      | WWE     | Countout         | ENDAX  | READ     | Double countouts are possible                       |
#      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
#      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |
#    When I fill in "Search" with "opponents"
#    Then I should see the following client messages
#      | ECW     | Pinfall          | me     | READ     | Pin both the opponent's shoulders against the mat   |
#      | WWE     | Disqualification | ENDAX  | UNREAD   | Strike an opponent with a foreign object            |
#      | WWE     | Draw             | me     | ARCHIVED | If both opponents are simultaneously disqualified   |
      
# Scenario: Post a message
#      Given I have the project "Ogg Theora"
#      When I go to the new message page
#      And I fill in "Title" with "Ruby is a dynamic programming language"
#      And I fill in "Content" on new message form with
#        """
#        Ruby is a dynamic programming language with a complex but expressive grammar and a core
#        class library with a rich and powerful API. Ruby draws inspiration from Lisp, Smalltalk,
#        and Perl, but uses a grammar that is easy for C and Java programmers to learn.
#        """
#     And I press "Post"
#     Then I should see
#        """
#        Ruby is a dynamic programming language
#        """
  
Feature: Clients manage requests
  In order to manage requests for my projects
  As a client
  I should be able to create, view, edit requests
  And I should be able to upload files, add changes and exchange messages with managers

  Background:
    Given I am logged in as a client
    And I am on the client request list page


  Scenario: Create a request
    Given I have the project "Ogg Theora"
    When I go to the client request list page
    And I follow "Ogg Theora"
    And I follow "New"
    And I fill in "Title" with <title>
    And I fill in "Description" with "<description>"
  	And I select "High" from "Priority"
    And I attach the file at "test/fixtures/mockup.pdf" to "attach_files[0][file]"
    And I press "Request"
    And I should see the following
      | title        | description             | priority |
      | Test EXTREME | This is testing EXTREME | Extreme  |
      | Test HIGH    | This is testing HIGH    | High     |
      | Test MEDIUM  | This is testing MEDIUM  | Medium   |
      | Test LOW     | This is testing LOW     | Low      |

  # TODO Create a request without selecting a project
  # By default, when clicking "Request" on the top menu, a client will see requests from all projects

  Scenario: Show all requests
    Given I have the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Typekit | Banishing blight | High     | A font service provider turns Verdana into Vavoom         |
      | Regis   | Key/value store  | Medium   | Need a lightweight key/value store?                       |
      | Snowl   | Feed reader      | Low      | It's not perfect yet, but the long term future looks good |
    When I follow "Requirement"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Typekit | Banishing blight | High     | A font service provider turns Verdana into Vavoom         |
      | Regis   | Key/value store  | Medium   | Need a lightweight key/value store?                       |
      | Snowl   | Feed reader      | Low      | It's not perfect yet, but the long term future looks good |


  Scenario: Show requests by project
    Given I have the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Android | Debugging        | Extreme  | Start up the Android Emulator and debug your application  |
      | Backups | Capacity         | Low      | How much are you storing                                  |
      | Backups | Data transfer    | Low      | How much data is transferred in and out                   |
    When I follow "All"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Android | Debugging        | Extreme  | Start up the Android Emulator and debug your application  |
      | Backups | Capacity         | Low      | How much are you storing                                  |
      | Backups | Data transfer    | Low      | How much data is transferred in and out                   |
    When I follow "Android"
    Then I should see the following requests
      | project | title            | priority | description                                               |    
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Android | Debugging        | Extreme  | Start up the Android Emulator and debug your application  |
    When I follow "Backups"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Backups | Capacity         | Low      | How much are you storing                                  |
      | Backups | Data transfer    | Low      | How much data is transferred in and out                   |


  Scenario: Show request by priority
    Given I have the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Android | Debugging        | Extreme  | Start up the Android Emulator and debug your application  |
      | Typekit | Banishing blight | High     | A font service provider turns Verdana into Vavoom         |
      | Regis   | Key/value store  | Medium   | Need a lightweight key/value store?                       |
      | Backups | Capacity         | Low      | How much are you storing                                  |
      | Backups | Data transfer    | Low      | How much data is transferred in and out                   |
    When I follow "All"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Android | Debugging        | Extreme  | Start up the Android Emulator and debug your application  |
      | Typekit | Banishing blight | High     | A font service provider turns Verdana into Vavoom         |
      | Regis   | Key/value store  | Medium   | Need a lightweight key/value store?                       |
      | Backups | Capacity         | Low      | How much are you storing                                  |
      | Backups | Data transfer    | Low      | How much data is transferred in and out                   |
    When I follow "Extreme"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application    |
      | Android | Debugging        | Extreme  | Start up the Android Emulator and debug your application  |
    When I follow "High"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Typekit | Banishing blight | High     | A font service provider turns Verdana into Vavoom         |
    When I follow "Medium"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Regis   | Key/value store  | Medium   | Need a lightweight key/value store?                       |
    When I follow "Low"
    Then I should see the following requests
      | project | title            | priority | description                                               |
      | Backups | Capacity         | Low      | How much are you storing                                  |
      | Backups | Data transfer    | Low      | How much data is transferred in and out                   |

  Scenario: Show a request
    Given I have the following requests
      | project | title            | priority | description                                            | created_at |  
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application | yesterday  |
    When I go to the client request view page of "Data persistence"
    Then I should see "Data persistence"
    #And I should see "Yesterday"
    And I should see "Build on our Android-based TicketResponder application"
    And I should see "Priority" with value "Extreme"
    And I should see "State" with value "New"


  Scenario Outline: Change state
    Given I have the following requests
      | project | title            | priority | description                                            | state |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application | met   |
    When I go to the client request view page for "Data persistence"    
    And I select "<state>" from "State"
    And I press "Update"
    Then I should see "State" with value "<state>"
    Examples:
      | state    |
      | Unmet    |
      | Archived |      

  Scenario Outline: Change priority
    Given I have the following requests
      | project | title            | priority | description                                            |
      | Android | Data persistence | Extreme  | Build on our Android-based TicketResponder application |
    When I go to the client request view page for "Data persistence"    
    And I select "<priority>" from "Priority"
    And I press "Update"
    Then I should see "Priority" with value "<priority>"
    Examples:
      | priority  |
      | Extreme   |
      | High      |
      | Medium    |
      | Low       |


@javascript
  Scenario: Show changes
    Given I have the following changes for the request "GUI development with Qt"
      | description                     | created_at |
      | Chewing on progress bars        | today      |
      | Making software easy to package | yesterday  |
      | Embracing the git index         | 09/09/2009 |
    When I go to the client request view page for "GUI development with Qt"
    Then I should see the following request changes
      | description                     | created_at |
      | Chewing on progress bars        | today      |
      | Making software easy to package | yesterday  |
      | Embracing the git index         | 09/09/2009 |


  Scenario Outline: Create a request change
    Given I have the following requests:
      | project     | title                   | description                                     |
      | Green Peace | GUI development with Qt | Demonstrate the core concepts of Qt programming |
    When I go to the client request view page for "GUI development with Qt"
    And I follow "New"
    And I fill in "Description" with "<description>"
    And I press "Save"
    Then I should see "<description>"
    Examples:
      | description                                  |
      | Implement 2 simple Qt programs               |
      | Check if Qt is available for Open Solaris 10 |
 

  Scenario: Show attached files
    Given I have the following requests:
      | project     | title                   | description              |
      | Green Peace | GUI development with Qt | Create an HTML prototype |
    And I have the following attached files for the request "GUI development with Qt"
      | Description | created_at |
      | Homepage    | today      |
      | Contact     | yesterday  |
      | About       | 09/09/2009 |
    And I am on the client request list page
    When I go to the client request view page for "GUI development with Qt"
    Then I should see the following attached files
      | Description |
      | Homepage    |
      | Contact     |
      | About       |


  @javascript
  Scenario Outline: Attach a file
    Given I have the following requests:
      | project     | title                   | description              |
      | Green Peace | GUI development with Qt | Create an HTML prototype |
    When I go to the client request view page for "GUI development with Qt"
    And I follow "New" within "#files"
    And I attach the file at "/test/fixtures/mockup.pdf" to "attachedFile__client_request[file]"
    And I fill in the note with "<description>" of attached file for "client request"
    And I press "Save" within "#files"
    Then I should see "<description>"
    Examples:
      | description |
      | Homepage    |
      | Contact     |
  
  @javascript
  Scenario: Edit attached file description
    Given I have the following requests:
      | project     | title                   | description              |
      | Green Peace | GUI development with Qt | Create an HTML prototype |
    Given I have the following attached files for the request "GUI development with Qt"
      | Description | created_at |
      | Homepage    | today      |
    When I go to the client request view page for "GUI development with Qt"
    And I click the text "Homepage" of the attached file
    And I change the text "Homepage" of the attached file to "Homepage screenshots"
    And I press "Save" within "#files"
    Then I should see "Homepage screenshots"

  @javascript
  Scenario: Delete an attached file
    Given I have the following requests:
      | project     | title                   | description              |
      | Green Peace | GUI development with Qt | Create an HTML prototype |
    And I have the following attached files for the request "GUI development with Qt"
      | Description | created_at |
      | Homepage    | today      |
    When I go to the client request view page for "GUI development with Qt"
    And I click the "Delete" link to delete
    Then I should not see "Homepage"


  @javascript
  Scenario: Delete a request change
    Given I have the following change for the request "GUI development with Qt"
      | description              |
      | Chewing on progress bars |
    When I go to the client request view page for "GUI development with Qt"
    And I click the "Delete" link to delete
    Then I should not see "Chewing on progress bars"

  @javascript
  Scenario: Edit a request change
    Given I have the following change for the request "GUI development with Qt"
      | description              |
      | Chewing on progress bars |
    When I go to the client request view page for "GUI development with Qt"
    And I click the text "Chewing on progress bars" of the change
    And I change the text "Chewing on progress bars" of the change to "Implement a progress bar for report aggregation"
    And I press "Save" within "#changes"
    Then I should see "Implement a progress bar for report aggregation"

  # SECTION Message
  Scenario: Show messages    
    Given I have the following messages for the request "Meaning of number"
      | sender | message                                                             | created_at |
      | John   | In blackjack, the Ten, Jack, Queen and King are all worth 10 points | today      |
      | Jim    | Apollo 11 was the first manned spacecraft to land on the Moon       | yesterday  |
      | Jasmine| The Western zodiac has twelve signs, as does the Chinese zodiac     | 11/03/1991 |

    When I go to the client request view page for "Meaning of number"
    Then I should see the following messages
      | sender  | message                                                             | created_at |
      | John    | In blackjack, the Ten, Jack, Queen and King are all worth 10 points |  today     |
      | Jim     | Apollo 11 was the first manned spacecraft to land on the Moon       | yesterday  |
      | Jasmine | The Western zodiac has twelve signs, as does the Chinese zodiac     | 11/03/1991 |

  
  @javascript
  Scenario Outline: Create a message
    Given I have the request "Meaning of number"
    When I go to the client request view page for "Meaning of number"
    And I follow "New" within "#client-discussion"    
    And I fill in the message with "<message>" of client discusstion for "client request"
    And I press "Create"    
    Examples:
      |title        | message                                                             |
      |In blackjack | In blackjack, the Ten, Jack, Queen and King are all worth 10 points |
     


  @javascript
  Scenario Outline: Reply a message
    Given I have the request "Meaning of number"
    And I have the message "Let's go" for the request "Meaning of number"
    When I go to the client request view page for "Meaning of number"
    And I should see "Let's go"
    And I click on "Let's go" to view full message
    And I follow "Reply"
    And I fill in "Content" on reply form with "<message>"
    And I press "Create"
    Examples:
    Then I should see "<message>"
      | message                                                             |
      | In blackjack, the Ten, Jack, Queen and King are all worth 10 points |      

  @javascript
  Scenario: Show a message
    Given I have the request "Meaning of number"
    And I have the below message for the request "Meaning of number"
      """
      World War I ended with an Armistice on November 11, 1918, which went into effect at
      11:00 am-the 11th hour on the 11th day of the 11th month of the year. Armistice Day is still
      observed on November 11 of each year, although it is now called Veteran's Day in the United
      States and Remembrance Day in the Commonwealth of Nations and parts of Europe.
      """
    When I go to the client request view page for "Meaning of number"
    And I click on "World War I ended with an Armistice" to view full message
    Then I should see
      """
      World War I ended with an Armistice on November 11, 1918, which went into effect at
      11:00 am-the 11th hour on the 11th day of the 11th month of the year. Armistice Day is still
      observed on November 11 of each year, although it is now called Veteran's Day in the United
      States and Remembrance Day in the Commonwealth of Nations and parts of Europe.
      """

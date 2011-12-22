Feature: Setting My Account information
  In order to change My account information
  As a user
  I want be able to edit my basic information

  Background:
    Given I am logged in as a client
 
  Scenario: Display my account information
    When I follow my account
    Then I should be on the "client account" page
    And I should see my account details
  Scenario: Edit my account
    Given I am on the "client account" page
    Then I follow "Edit"
    And I fill in "Name" with "New Name"
    And I fill in "Email" with "newmail@endax.com"
    And I fill in "Address" with "new address"
    And I fill in "Phone" with "123-123-1212"
    And I fill in "Link" with "http://testlinkedited.com"
    And I fill in "Password" with "newPass123"
    And I fill in "Password confirmation" with "newPass123"
    And I fill in "Description" with "New description"
    And I press "Save"
    Then I should be on the "client account" page
    And I should see "New Name"
    And I should see "newmail@endax.com"
    And I should see "new address"
    And I should see "123-123-1212"
    And I should see "http://testlinkedited.com"
    And I should see "New description"
#NO NEED TO IMPLEMENT NOW - LATER ITERATION
#Feature: viewing milestones as a worker
#  In order to manage view milestones for a given project
#  As a worker
#  I want be able to view a list of milestones and click on req (which brings me to specfic task)
#
#  Background:
#    Given I am logged in as a worker
#    And I am assigned to a complete project called "Project X"
#    And the complete project has "3" milestones that are a range of "late", "almost due", and "due eventually"
#    And the complete project "3" tasks (reqs) associated with each milestone
#    And I am on the milestones page
#
#  Scenario: view the current date
#    Then I should see the current date bar
#
#  Scenario: view the sorted milestones
#    Then I should see the milestones sorted by date, due first at the top, due last at the bottom
#
#  Scenario Outline: view all milestones related to my project
#    Then I should see a milestone that is <status> <placement> the current date bar with a date color of <color>
#    Examples:
#      | status | placement | color  |
#      | LATE   | above     | red    |
#      | NEAR   | below     | orange |
#      | FAR    | below     | green  |

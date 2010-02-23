Feature: Manage dogs with background
  In order to keep track of dogs
  As a user
  I want to be able to manage dogs

Background:
  Given there are no dogs

Scenario: Create a dog
  Given your mom
  When I create a dog
  And I view all dogs
  Then your mom should see a dog

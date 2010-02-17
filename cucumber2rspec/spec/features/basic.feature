Feature: Manage dogs
  In order to keep track of dogs
  As a user
  I want to be able to manage dogs

Scenario: Create a dog
  Given there are no dogs
  And your mom
  When I create a dog
  And I view all dogs
  Then your mom should see a dog

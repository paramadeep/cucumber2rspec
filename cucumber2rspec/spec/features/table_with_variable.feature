Feature: Manage dogs
  In order to keep track of dogs
  As a user
  I want to be able to manage dogs

Scenario: Create a dog
  Given there are no dogs
  And your mom
  When I create the following "dogs"
    | name  | breed            |
    | Rover | Golden Retriever |
    | Rex   | Boxer            |
  And I view all dogs
  Then your mom should see "Rover: Golden Retriever"

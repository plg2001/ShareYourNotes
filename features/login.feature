
Feature: Login
  Scenario: User can log in with valid credentials
    Given I am on the home page
    When I visit the Log In page
    And I fill in "Email" with "damiano.martelluzzi3@gmail.com"
    And I fill in "Password" with "prova1234"
    And I click "Log in"
    Then I should see "Signed in successfully."


Feature: Login
  Scenario: User can log in with valid credentials
    Given I have a confirmed user with email "test@gmail.com" and password "test12345" and username "test"
    Given I am on the home page
    When I visit the Log In page
    And I fill in "Email" with "test@gmail.com"
    And I fill in "Password" with "test12345"
    And I click "Log in"
    Then I should be on the home page
    Then I should see "Benvenuto test su ShareYourNotes"
    When I visit the page to upload note
    Then I should be on the upload note page
    And I fill in "Name" with "note_test"
    And I fill in "Description" with "note_test_descripion"
    And I attach a file with valid format
    Given A 3 Tags with name1 "Tag_Name1" and name2 "Tag_Name2" and name3 "Tag_Name2"
    When I check the checkbox for "Tag_Name1"
  
    



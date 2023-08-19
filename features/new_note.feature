#Test su il caricamento degli appunti

Feature: New Note
  Background:
    Given I have a confirmed user with email "test@gmail.com" and password "test12345" and username "test"
    Given A 3 Tags with name1 "Tag_Name1" and name2 "Tag_Name2" and name3 "Tag_Name3"
    Given A 3 Topics with name1 "Topic_Name1" and name2 "Topic_Name2" and name3 "Topic_Name3"
    Given A 3 Faculties with name1 "Faculty_Name1" and name2 "Faculty_Name2" and name3 "Faculty_Name3"
    Given I am on the home page
    When I visit the Log In page
    And I fill in "Email" with "test@gmail.com"
    And I fill in "Password" with "test12345"
    And I click "Log in"
    Then I should be on the home page
    Then I should see "Benvenuto test su ShareYourNotes"
    When I visit the page to upload note
    Then I should be on the upload note page
  Scenario: A valid user uploads a valid note
    And I fill in "Name" with "note_test"
    And I fill in "Description" with "note_test_descripion"
    And I attach a file with valid format
    When I check the tag checkbox for "Tag_Name1"
    Then I have the tag checkbox for "Tag_Name1" checked
    When I check the tag checkbox for "Tag_Name2"
    Then I have the tag checkbox for "Tag_Name2" checked
    When I check the topic checkbox for "Topic_Name1"
    Then I have the topic checkbox for "Topic_Name1" checked
    When I check the topic checkbox for "Topic_Name2"
    Then I have the topic checkbox for "Topic_Name2" checked
    When I select "Faculty_Name1" from the select faculty
    Then I have "Faculty_Name1" from the select faculty selected
    And I click "Carica"
    Then I should be on the note page
  Scenario: A valid user uploads an invalid note because miss the name
    And I fill in "Description" with "note_test_descripion"
    And I attach a file with valid format
    When I check the tag checkbox for "Tag_Name1"
    Then I have the tag checkbox for "Tag_Name1" checked
    When I check the topic checkbox for "Topic_Name1"
    Then I have the topic checkbox for "Topic_Name1" checked
    When I select "Faculty_Name1" from the select faculty
    Then I have "Faculty_Name1" from the select faculty selected
    And I click "Carica"
    Then I should be on the new page
  Scenario: A valid user uploads an invalid note because miss the description
    And I fill in "Name" with "note_test"
    And I attach a file with valid format
    When I check the tag checkbox for "Tag_Name1"
    Then I have the tag checkbox for "Tag_Name1" checked
    When I check the topic checkbox for "Topic_Name1"
    Then I have the topic checkbox for "Topic_Name1" checked
    When I select "Faculty_Name1" from the select faculty
    Then I have "Faculty_Name1" from the select faculty selected
    And I click "Carica"
    Then I should be on the new page
  Scenario: A valid user uploads an invalid note because miss the file
    And I fill in "Name" with "note_test"
    And I fill in "Description" with "note_test_descripion"
    When I check the tag checkbox for "Tag_Name1"
    Then I have the tag checkbox for "Tag_Name1" checked
    When I check the topic checkbox for "Topic_Name1"
    Then I have the topic checkbox for "Topic_Name1" checked
    When I select "Faculty_Name1" from the select faculty
    Then I have "Faculty_Name1" from the select faculty selected
    And I click "Carica"
    Then I should be on the new page
  Scenario: A valid user uploads an invalid note because miss the tags
    And I fill in "Name" with "note_test"
    And I fill in "Description" with "note_test_descripion"
    And I attach a file with valid format
    When I check the topic checkbox for "Topic_Name1"
    Then I have the topic checkbox for "Topic_Name1" checked
    When I select "Faculty_Name1" from the select faculty
    Then I have "Faculty_Name1" from the select faculty selected
    And I click "Carica"
    Then I should be on the new page
  Scenario: A valid user uploads an invalid note because miss the topics
    And I fill in "Name" with "note_test"
    And I fill in "Description" with "note_test_descripion"
    And I attach a file with valid format
    When I check the tag checkbox for "Tag_Name1"
    Then I have the tag checkbox for "Tag_Name1" checked
    When I select "Faculty_Name1" from the select faculty
    Then I have "Faculty_Name1" from the select faculty selected
    And I click "Carica"
    Then I should be on the new page
  Scenario: A valid user uploads an invalid note because miss the faculty
    And I fill in "Name" with "note_test"
    And I fill in "Description" with "note_test_descripion"
    And I attach a file with valid format
    When I check the tag checkbox for "Tag_Name1"
    Then I have the tag checkbox for "Tag_Name1" checked
    When I check the topic checkbox for "Topic_Name1"
    Then I have the topic checkbox for "Topic_Name1" checked
    And I click "Carica"
    Then I should be on the new page





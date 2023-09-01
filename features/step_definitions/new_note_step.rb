#Test su il caricamento degli appunti

Given ("I have a confirmed user with email {string} and password {string} and username {string}") do |email,password,username|
  @user = User.create(email: email, password: password,password_confirmation: password,username: username)
  @user.skip_confirmation!
  @user.save!
end

Given("A 3 Tags with name1 {string} and name2 {string} and name3 {string}") do |name1,name2,name3|
  @tag1 = Tag.create(name: name1)
  @tag1.save!
  @tag2 = Tag.create(name: name2)
  @tag2.save!
  @tag3 = Tag.create(name: name3)
  @tag3.save!
end

Given("A 3 Topics with name1 {string} and name2 {string} and name3 {string}") do |name1,name2,name3|
  @topic1 = Topic.create(name: name1)
  @topic1.save!
  @topic2 = Topic.create(name: name2)
  @topic2.save!
  @topic3 = Topic.create(name: name3)
  @topic3.save!
end

Given("A 3 Faculties with name1 {string} and name2 {string} and name3 {string}") do |name1,name2,name3|
  @faculty1 = Faculty.create(name: name1)
  @faculty1.save!
  @faculty2 = Faculty.create(name: name2)
  @faculty2.save!
  @faculty3 = Faculty.create(name: name3)
  @faculty3.save!
end

Given("I am on the home page") do
  visit root_path
end

When("I visit the Log In page") do
  visit signin_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

And("I click {string}") do |button|
  click_button button
end

Then("I should be on the home page") do
  expect(current_path).to eq root_path
end

Then("I should see {string} in {string}") do |content, content2|
  expect(page.find(content2)).to have_text(content)
end

When("I visit the page to upload note") do
  visit new_note_path
end

Then("I should be on the upload note page") do
  expect(current_path).to eq new_note_path
end

And("I attach a file with valid format") do
  attach_file("file", Rails.root.join('features/support/files/file.pdf')) 
end

When("I check the tag checkbox for {string}") do |tag_name|
  tag = Tag.find_by(name: tag_name)
  expect(find('#tag'+tag.id.to_s)).not_to be_checked
  find('input', id: 'tag'+tag.id.to_s).click
end

Then("I have the tag checkbox for {string} checked") do |tag_name|
  tag = Tag.find_by(name: tag_name)
  expect(find('#tag'+tag.id.to_s)).to be_checked
end

When("I check the topic checkbox for {string}") do |topic_name|
  topic = Topic.find_by(name: topic_name)
  expect(find('#topic'+topic.id.to_s)).not_to be_checked
  find('input', id: 'topic'+topic.id.to_s).click
end

Then("I have the topic checkbox for {string} checked") do |topic_name|
  topic = Topic.find_by(name: topic_name)
  expect(find('#topic'+topic.id.to_s)).to be_checked
end

When("I select {string} from the select faculty") do |faculty_name|
  expect(page).to have_select('note_faculty_id')
  select(faculty_name, from: 'note_faculty_id')
end

Then("I have {string} from the select faculty selected") do |faculty_name|
  expect(page).to have_select('note_faculty_id', selected: faculty_name)
end

Then("I should be on the note page") do
  expect(current_path).to eq "/notes/1"
end
 
Then("I should be on the new page") do
  expect(current_path).to eq "/notes"
end
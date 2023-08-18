Given ("I have a confirmed user with email {string} and password {string} and username {string}") do |email,password,username|
  @user = User.create(email: email, password: password,password_confirmation: password,username: username)
  @user.skip_confirmation!
  @user.save!
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

# In features/step_definitions/login_steps.rb

Then("I should be on the home page") do
  expect(current_path).to eq root_path
end


Then("I should see {string}") do |content|
  expect(page.find('#messaggio_login')).to have_text(content)
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

Given("A 3 Tags with name1 {string} and name2 {string} and name3 {string}") do |name1,name2,name3|
  @tag1 = Tag.create(name: name1)
  @tag1.save!
  @tag2 = Tag.create(name: name2)
  @tag2.save!
  @tag3 = Tag.create(name: name3)
  @tag3.save!
end

When("I check the checkbox for {string}") do |tag_name|
  tag = Tag.find_by(name: tag_name)
  expect(find('#tag'+tag.id.to_s)).not_to be_checked
  find('input', id: 'tag'+tag.id.to_s).click

  expect(find("#tag"+tag.id.to_s)).to be_checked
end




 
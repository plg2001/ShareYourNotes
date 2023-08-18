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
  puts page.body
end


Then("I should see {string}") do |content|
  
  expect(page).to have_content content
end
 
#Test sulla scrittura dei commenti


And("I should not see {string}") do |content|
    expect(page).not_to have_selector(content)
end
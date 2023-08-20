#Test sulla scrittura dei commenti

And("I should see {string} in {string}") do |content, content2|
    expect(page.find(content2)).to have_text(content)
end

And("I not should see {string}") do |content|
    expect(page).not_to have_selector(content)
end
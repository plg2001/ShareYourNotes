require "application_system_test_case"

class RichiestaAdminsTest < ApplicationSystemTestCase
  setup do
    @richiesta_admin = richiesta_admins(:one)
  end

  test "visiting the index" do
    visit richiesta_admins_url
    assert_selector "h1", text: "Richiesta Admins"
  end

  test "creating a Richiesta admin" do
    visit richiesta_admins_url
    click_on "New Richiesta Admin"

    fill_in "Content", with: @richiesta_admin.content
    fill_in "User", with: @richiesta_admin.user_id
    click_on "Create Richiesta admin"

    assert_text "Richiesta admin was successfully created"
    click_on "Back"
  end

  test "updating a Richiesta admin" do
    visit richiesta_admins_url
    click_on "Edit", match: :first

    fill_in "Content", with: @richiesta_admin.content
    fill_in "User", with: @richiesta_admin.user_id
    click_on "Update Richiesta admin"

    assert_text "Richiesta admin was successfully updated"
    click_on "Back"
  end

  test "destroying a Richiesta admin" do
    visit richiesta_admins_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Richiesta admin was successfully destroyed"
  end
end

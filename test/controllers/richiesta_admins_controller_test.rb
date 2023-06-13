require "test_helper"

class RichiestaAdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @richiesta_admin = richiesta_admins(:one)
  end

  test "should get index" do
    get richiesta_admins_url
    assert_response :success
  end

  test "should get new" do
    get new_richiesta_admin_url
    assert_response :success
  end

  test "should create richiesta_admin" do
    assert_difference('RichiestaAdmin.count') do
      post richiesta_admins_url, params: { richiesta_admin: { content: @richiesta_admin.content, user_id: @richiesta_admin.user_id } }
    end

    assert_redirected_to richiesta_admin_url(RichiestaAdmin.last)
  end

  test "should show richiesta_admin" do
    get richiesta_admin_url(@richiesta_admin)
    assert_response :success
  end

  test "should get edit" do
    get edit_richiesta_admin_url(@richiesta_admin)
    assert_response :success
  end

  test "should update richiesta_admin" do
    patch richiesta_admin_url(@richiesta_admin), params: { richiesta_admin: { content: @richiesta_admin.content, user_id: @richiesta_admin.user_id } }
    assert_redirected_to richiesta_admin_url(@richiesta_admin)
  end

  test "should destroy richiesta_admin" do
    assert_difference('RichiestaAdmin.count', -1) do
      delete richiesta_admin_url(@richiesta_admin)
    end

    assert_redirected_to richiesta_admins_url
  end
end

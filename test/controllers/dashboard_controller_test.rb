require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get root_url

    assert_response :success
    assert_select "h1", "Shop Floor"
    assert_select "a[href=?]", new_session_path, text: "Sign in"
    assert_select "button", text: "Sign out", count: 0
  end

  test "shows active work orders" do
    work_order = work_orders(:active)

    get root_url

    assert_response :success
    assert_select "a", text: work_order.number
  end

  test "shows sign out to authenticated users" do
    sign_in_as(users(:one))

    get root_url

    assert_response :success
    assert_select "button", "Sign out"
    assert_select "a", text: "Sign in", count: 0
  end
end

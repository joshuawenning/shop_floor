require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get show" do
    get root_url

    assert_response :success
    assert_select "h1", "Shop Floor"
  end

  test "shows active work orders" do
    work_order = work_orders(:active)

    get root_url

    assert_response :success
    assert_select "a", text: work_order.number
  end
end

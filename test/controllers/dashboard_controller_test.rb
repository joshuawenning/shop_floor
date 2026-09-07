require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get root_url

    assert_response :success
    assert_select "h1", "Shop Floor"
  end

  test "shows active work orders" do
    part = Part.create!(
      number: "DASH-PART-001",
      name: "Dashboard Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "WO-DASH-001",
      part: part,
      quantity: 50,
      due_on: 1.week.from_now,
      status: :active
    )

    get root_url

    assert_response :success
    assert_select "a", text: work_order.number
  end
end

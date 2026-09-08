require "test_helper"

class WorkOrdersControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should create work order" do
    part = parts(:control_board)

    assert_difference("WorkOrder.count", 1) do
      post work_orders_url, params: {
        work_order: {
          number: "WO-TEST-100",
          part_id: part.id,
          quantity: 50,
          due_on: 1.week.from_now.to_date,
          status: "scheduled"
        }
      }
    end

    work_order = WorkOrder.find_by!(number: "WO-TEST-100")

    assert_equal part, work_order.part
    assert_redirected_to work_order_url(work_order)
  end

  test "should update work order" do
    work_order = work_orders(:scheduled)

    patch work_order_url(work_order), params: {
      work_order: {
        status: "active"
      }
    }

    assert_redirected_to work_order_url(work_order)

    work_order.reload

    assert_equal "active", work_order.status
  end

  test "should destroy work order" do
    work_order = work_orders(:scheduled)

    assert_difference("WorkOrder.count", -1) do
      delete work_order_url(work_order)
    end

    assert_redirected_to work_orders_url
  end

  test "should not complete work order with unfinished operations" do
    work_order = work_orders(:active)

    patch work_order_url(work_order), params: {
      work_order: {
        status: "completed"
      }
    }

    assert_response :unprocessable_entity

    work_order.reload

    assert_not work_order.completed?
  end
end

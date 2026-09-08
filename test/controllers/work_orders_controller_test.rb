require "test_helper"

class WorkOrdersControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "allows public read access without management controls" do
    sign_out
    work_order = work_orders(:active)

    get work_orders_url

    assert_response :success
    assert_select "a", text: "New work order", count: 0

    get work_order_url(work_order)

    assert_response :success
    assert_select "a", text: "Add operation", count: 0
    assert_select "a", text: "Edit", count: 0
    assert_select "button", text: "Delete", count: 0
  end

  test "shows management controls to authenticated users" do
    work_order = work_orders(:active)

    get work_orders_url

    assert_response :success
    assert_select "a[href=?]", new_work_order_path, text: "New work order"

    get work_order_url(work_order)

    assert_response :success
    assert_select "a[href=?]", new_work_order_operation_path(work_order), text: "Add operation"
    assert_select "a[href=?]", edit_work_order_path(work_order), text: "Edit"
    assert_select "button", "Delete"
  end

  test "requires authentication for management actions" do
    sign_out
    work_order = work_orders(:scheduled)

    get new_work_order_url
    assert_redirected_to new_session_path

    assert_no_difference("WorkOrder.count") do
      post work_orders_url, params: {
        work_order: {
          number: "PRIVATE-WO-001",
          part_id: parts(:control_board).id,
          quantity: 10,
          due_on: 1.week.from_now.to_date,
          status: "scheduled"
        }
      }
    end
    assert_redirected_to new_session_path

    get edit_work_order_url(work_order)
    assert_redirected_to new_session_path

    assert_no_changes -> { work_order.reload.quantity } do
      patch work_order_url(work_order), params: { work_order: { quantity: 25 } }
    end
    assert_redirected_to new_session_path

    assert_no_difference("WorkOrder.count") do
      delete work_order_url(work_order)
    end
    assert_redirected_to new_session_path
  end

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

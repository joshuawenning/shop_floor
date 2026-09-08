require "test_helper"

class OperationsControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication for management actions" do
    work_order = work_orders(:active)
    operation = operations(:assembly)

    get new_work_order_operation_url(work_order)
    assert_redirected_to new_session_path

    assert_no_difference("Operation.count") do
      post work_order_operations_url(work_order), params: {
        operation: {
          name: "Packaging",
          position: 4,
          status: "pending"
        }
      }
    end
    assert_redirected_to new_session_path

    get edit_work_order_operation_url(work_order, operation)
    assert_redirected_to new_session_path

    assert_no_changes -> { operation.reload.name } do
      patch work_order_operation_url(work_order, operation), params: {
        operation: { name: "Changed" }
      }
    end
    assert_redirected_to new_session_path

    assert_no_difference("Operation.count") do
      delete work_order_operation_url(work_order, operation)
    end
    assert_redirected_to new_session_path
  end
end

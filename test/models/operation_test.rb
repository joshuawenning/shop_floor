require "test_helper"

class OperationTest < ActiveSupport::TestCase
  test "belongs to a work order" do
    operation = operations(:assembly)
    work_order = work_orders(:active)

    assert_equal work_order, operation.work_order
    assert_includes work_order.operations, operation
  end

  test "requires a name" do
    operation = Operation.new(position: 1)

    assert_not operation.valid?
    assert_includes operation.errors[:name], "can't be blank"
  end

  test "position must be greater than zero" do
    operation = Operation.new(
      name: "Assembly",
      position: 0
    )

    assert_not operation.valid?
  end

  test "records completed at when completed" do
    operation = operations(:inspection)

    assert_nil operation.completed_at

    operation.completed!

    assert_not_nil operation.completed_at
  end

  test "clears completed at when no longer completed" do
    operation = operations(:cutting)

    assert_not_nil operation.completed_at

    operation.in_progress!

    assert_nil operation.completed_at
  end
end

require "test_helper"

class OperationTest < ActiveSupport::TestCase
  test "belongs to a work order" do
    part = Part.create!(
      number: "OP-PART-001",
      name: "Test Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "OP-WO-001",
      part: part,
      quantity: 20,
      due_on: 1.week.from_now
    )

    operation = Operation.create!(
      work_order: work_order,
      name: "Assembly",
      position: 1
    )

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
    part = Part.create!(
      number: "COMP-PART-001",
      name: "Test Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "COMP-WO-001",
      part: part,
      quantity: 10,
      due_on: 1.week.from_now
    )

    operation = Operation.create!(
      work_order: work_order,
      name: "Assembly",
      position: 1,
      status: :pending
    )

    assert_nil operation.completed_at

    operation.completed!

    assert_not_nil operation.completed_at
  end

  test "clears completed at when no longer completed" do
    part = Part.create!(
      number: "REOPEN-PART-001",
      name: "Test Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "REOPEN-WO-001",
      part: part,
      quantity: 10,
      due_on: 1.week.from_now
    )

    operation = Operation.create!(
      work_order: work_order,
      name: "Inspection",
      position: 1,
      status: :completed
    )

    assert_not_nil operation.completed_at

    operation.in_progress!

    assert_nil operation.completed_at
  end
end

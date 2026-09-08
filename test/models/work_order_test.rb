require "test_helper"

class WorkOrderTest < ActiveSupport::TestCase
  test "belongs to a part" do
    work_order = work_orders(:scheduled)
    part = parts(:control_board)

    assert_equal part, work_order.part
    assert_includes part.work_orders, work_order
  end

  test "requires a number" do
    work_order = WorkOrder.new(
      part: parts(:control_board),
      quantity: 50,
      due_on: 1.week.from_now
    )

    assert_not work_order.valid?
    assert_includes work_order.errors[:number], "can't be blank"
  end

  test "requires quantity greater than zero" do
    work_order = WorkOrder.new(
      number: "WO-1002",
      part: parts(:control_board),
      quantity: 0,
      due_on: 1.week.from_now
    )

    assert_not work_order.valid?
  end

  test "is overdue when due date has passed" do
    work_order = work_orders(:overdue)

    assert work_order.overdue?
  end

  test "is not overdue when due date is in the future" do
    work_order = work_orders(:scheduled)

    assert_not work_order.overdue?
  end

  test "completed work order is not overdue" do
    work_order = work_orders(:overdue)
    work_order.status = :completed

    assert_not work_order.overdue?
  end

  test "cannot be completed with unfinished operations" do
    work_order = work_orders(:active)

    work_order.status = :completed

    assert_not work_order.valid?
    assert_includes(
      work_order.errors[:status],
      "cannot be completed while operations remain unfinished"
    )
  end

  test "can be completed when all operations are completed" do
    work_order = work_orders(:active)
    operations(:assembly).completed!
    operations(:inspection).completed!

    work_order.status = :completed

    assert work_order.valid?
  end

  test "cannot be completed without operations" do
    work_order = work_orders(:scheduled)
    work_order.status = :completed

    assert_not work_order.valid?
    assert_includes(
      work_order.errors[:status],
      "cannot be completed without operations"
    )
  end

  test "overdue scope includes past-due active work orders" do
    overdue = work_orders(:overdue)
    future = work_orders(:active)

    assert_includes WorkOrder.overdue, overdue
    assert_not_includes WorkOrder.overdue, future
  end

  test "overdue scope excludes completed work orders" do
    work_order = work_orders(:active)
    work_order.update!(due_on: 1.day.ago.to_date)
    operations(:assembly).completed!
    operations(:inspection).completed!
    work_order.completed!

    assert_not_includes WorkOrder.overdue, work_order
  end
end

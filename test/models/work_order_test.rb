require "test_helper"

class WorkOrderTest < ActiveSupport::TestCase
  test "belongs to a part" do
    part = Part.create!(
      number: "PCB-1000",
      name: "Control Board",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "WO-1000",
      part: part,
      quantity: 50,
      due_on: 1.week.from_now
    )

    assert_equal part, work_order.part
    assert_includes part.work_orders, work_order
  end

  test "requires a number" do
    part = Part.create!(
      number: "PCB-1001",
      name: "Control Board",
      inventory_quantity: 10
    )

    work_order = WorkOrder.new(
      part: part,
      quantity: 50,
      due_on: 1.week.from_now
    )

    assert_not work_order.valid?
    assert_includes work_order.errors[:number], "can't be blank"
  end

  test "requires quantity greater than zero" do
    part = Part.create!(
      number: "PCB-1002",
      name: "Control Board",
      inventory_quantity: 10
    )

    work_order = WorkOrder.new(
      number: "WO-1002",
      part: part,
      quantity: 0,
      due_on: 1.week.from_now
    )

    assert_not work_order.valid?
  end

  test "is overdue when due date has passed" do
    part = Part.create!(
      number: "PCB-2000",
      name: "Control Board",
      inventory_quantity: 10
    )

    work_order = WorkOrder.new(
      number: "WO-2000",
      part: part,
      quantity: 50,
      due_on: 1.day.ago.to_date,
      status: :active
    )

    assert work_order.overdue?
  end

  test "is not overdue when due date is in the future" do
    part = Part.create!(
      number: "PCB-2001",
      name: "Control Board",
      inventory_quantity: 10
    )

    work_order = WorkOrder.new(
      number: "WO-2001",
      part: part,
      quantity: 50,
      due_on: 1.day.from_now.to_date,
      status: :active
    )

    assert_not work_order.overdue?
  end

  test "completed work order is not overdue" do
    part = Part.create!(
      number: "PCB-2002",
      name: "Control Board",
      inventory_quantity: 10
    )

    work_order = WorkOrder.new(
      number: "WO-2002",
      part: part,
      quantity: 50,
      due_on: 1.day.ago.to_date,
      status: :completed
    )

    assert_not work_order.overdue?
  end

  test "cannot be completed with unfinished operations" do
    part = Part.create!(
      number: "RULE-PART-001",
      name: "Test Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "RULE-WO-001",
      part: part,
      quantity: 10,
      due_on: 1.week.from_now
    )

    work_order.operations.create!(
      name: "Assembly",
      position: 1,
      status: :completed
    )

    work_order.operations.create!(
      name: "Inspection",
      position: 2,
      status: :pending
    )

    work_order.status = :completed

    assert_not work_order.valid?
    assert_includes(
      work_order.errors[:status],
      "cannot be completed while operations remain unfinished"
    )
  end

  test "can be completed when all operations are completed" do
    part = Part.create!(
      number: "DONE-PART-001",
      name: "Test Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.create!(
      number: "DONE-WO-001",
      part: part,
      quantity: 10,
      due_on: 1.week.from_now
    )

    work_order.operations.create!(
      name: "Assembly",
      position: 1,
      status: :completed
    )

    work_order.operations.create!(
      name: "Inspection",
      position: 2,
      status: :completed
    )

    work_order.status = :completed

    assert work_order.valid?
  end

  test "cannot be completed without operations" do
    part = Part.create!(
      number: "EMPTY-PART-001",
      name: "Test Part",
      inventory_quantity: 10
    )

    work_order = WorkOrder.new(
      number: "EMPTY-WO-001",
      part: part,
      quantity: 10,
      due_on: 1.week.from_now,
      status: :completed
    )

    assert_not work_order.valid?
    assert_includes(
      work_order.errors[:status],
      "cannot be completed without operations"
    )
  end
end

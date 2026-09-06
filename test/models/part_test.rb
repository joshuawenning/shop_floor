require "test_helper"

class PartTest < ActiveSupport::TestCase
  test "requires a number" do
    part = Part.new(
      name: "Control Board Assembly",
      inventory_quantity: 10
    )

    assert_not part.valid?
    assert_includes part.errors[:number], "can't be blank"
  end

  test "requires a unique number" do
    Part.create!(
      number: "PCB-4421",
      name: "Control Board Assembly",
      inventory_quantity: 10
    )

    duplicate = Part.new(
      number: "PCB-4421",
      name: "Another Part",
      inventory_quantity: 20
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:number], "has already been taken"
  end

  test "requires a name" do
    part = Part.new(
      number: "PCB-4421",
      inventory_quantity: 10
    )

    assert_not part.valid?
    assert_includes part.errors[:name], "can't be blank"
  end

  test "inventory quantity cannot be negative" do
    part = Part.new(
      number: "PCB-4421",
      name: "Control Board Assembly",
      inventory_quantity: -1
    )

    assert_not part.valid?
    assert_includes(
      part.errors[:inventory_quantity],
      "must be greater than or equal to 0"
    )
  end
end
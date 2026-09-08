require "test_helper"

class PartsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get parts_url

    assert_response :success
  end

  test "should show part" do
    part = Part.create!(
      number: "PCB-4421",
      name: "Control Board Assembly",
      revision: "C",
      inventory_quantity: 184
    )

    get part_url(part)

    assert_response :success
    assert_select "h1", "PCB-4421"
  end

  test "should get new" do
    get new_part_url

    assert_response :success
  end

  test "should create part" do
    assert_difference("Part.count", 1) do
      post parts_url, params: {
        part: {
          number: "INV-2200",
          name: "Inverter Housing",
          revision: "A",
          inventory_quantity: 35
        }
      }
    end

    part = Part.find_by!(number: "INV-2200")

    assert_redirected_to part_url(part)
  end

  test "should not create invalid part" do
    assert_no_difference("Part.count") do
      post parts_url, params: {
        part: {
          number: "",
          name: "",
          inventory_quantity: -1
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    part = Part.create!(
      number: "EDIT-001",
      name: "Editable Part",
      inventory_quantity: 10
    )

    get edit_part_url(part)

    assert_response :success
  end

  test "should update part" do
    part = Part.create!(
      number: "UPDATE-001",
      name: "Original Name",
      inventory_quantity: 10
    )

    patch part_url(part), params: {
      part: {
        name: "Updated Name"
      }
    }

    assert_redirected_to part_url(part)

    # THe Ruby object created before the HTTP request still has its old in-memory attributes.
    # Ask Active Record to fetch the current record from the database again.
    part.reload

    assert_equal "Updated Name", part.name
  end

  test "should not update invalid part" do
    part = Part.create!(
      number: "INVALID-001",
      name: "Valid Name",
      inventory_quantity: 10
    )

    patch part_url(part), params: {
      part: {
        inventory_quantity: -10
      }
    }

    assert_response :unprocessable_entity

    part.reload

    assert_equal 10, part.inventory_quantity
  end

  test "should destroy part" do
    part = Part.create!(
      number: "DELETE-001",
      name: "Disposable Part",
      inventory_quantity: 10
    )

    assert_difference("Part.count", -1) do
      delete part_url(part)
    end

    assert_redirected_to parts_url
  end
end

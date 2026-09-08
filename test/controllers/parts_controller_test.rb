require "test_helper"

class PartsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get parts_url

    assert_response :success
    assert_select "a[href=?]", new_part_path, text: "New part"
  end

  test "should show part" do
    part = parts(:control_board)

    get part_url(part)

    assert_response :success
    assert_select "h1", "PCB-4421"
    assert_select "a[href=?]", edit_part_path(part), text: "Edit"
    assert_select "button", "Delete"
  end

  test "allows public read access without management controls" do
    sign_out
    part = parts(:control_board)

    get parts_url

    assert_response :success
    assert_select "a", text: "New part", count: 0

    get part_url(part)

    assert_response :success
    assert_select "a", text: "Edit", count: 0
    assert_select "button", text: "Delete", count: 0
  end

  test "requires authentication for management actions" do
    sign_out
    part = parts(:control_board)
    disposable_part = Part.create!(
      number: "PRIVATE-DELETE-001",
      name: "Disposable Part",
      inventory_quantity: 0
    )

    get new_part_url
    assert_redirected_to new_session_path

    assert_no_difference("Part.count") do
      post parts_url, params: {
        part: {
          number: "PRIVATE-CREATE-001",
          name: "Private Part",
          inventory_quantity: 0
        }
      }
    end
    assert_redirected_to new_session_path

    get edit_part_url(part)
    assert_redirected_to new_session_path

    assert_no_changes -> { part.reload.name } do
      patch part_url(part), params: { part: { name: "Changed" } }
    end
    assert_redirected_to new_session_path

    assert_no_difference("Part.count") do
      delete part_url(disposable_part)
    end
    assert_redirected_to new_session_path
  end

  test "should get new" do
    get new_part_url

    assert_response :success
  end

  test "should create part" do
    assert_difference("Part.count", 1) do
      post parts_url, params: {
        part: {
          number: "BRKT-3300",
          name: "Mounting Bracket",
          revision: "A",
          inventory_quantity: 35
        }
      }
    end

    part = Part.find_by!(number: "BRKT-3300")

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
    part = parts(:control_board)

    get edit_part_url(part)

    assert_response :success
  end

  test "should update part" do
    part = parts(:control_board)

    patch part_url(part), params: {
      part: {
        name: "Updated Name"
      }
    }

    assert_redirected_to part_url(part)

    part.reload

    assert_equal "Updated Name", part.name
  end

  test "should not update invalid part" do
    part = parts(:inverter_housing)
    original_quantity = part.inventory_quantity

    patch part_url(part), params: {
      part: {
        inventory_quantity: -10
      }
    }

    assert_response :unprocessable_entity

    part.reload

    assert_equal original_quantity, part.inventory_quantity
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

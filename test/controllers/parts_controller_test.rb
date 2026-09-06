require "test_helper"

class PartsControllerTest < ActionDispatch::IntegrationTest
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
end

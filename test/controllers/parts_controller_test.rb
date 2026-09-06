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
end

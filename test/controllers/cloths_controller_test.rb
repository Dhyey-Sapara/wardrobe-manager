require "test_helper"

class ClothsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cloths_index_url
    assert_response :success
  end

  test "should get show" do
    get cloths_show_url
    assert_response :success
  end

  test "should get new" do
    get cloths_new_url
    assert_response :success
  end

  test "should get edit" do
    get cloths_edit_url
    assert_response :success
  end
end

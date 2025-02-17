require "test_helper"

class Enterprise::DiscussionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get enterprise_discussions_index_url
    assert_response :success
  end

  test "should get show" do
    get enterprise_discussions_show_url
    assert_response :success
  end
end

require "test_helper"

class Freelancer::DiscussionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get freelancer_discussions_index_url
    assert_response :success
  end

  test "should get show" do
    get freelancer_discussions_show_url
    assert_response :success
  end
end

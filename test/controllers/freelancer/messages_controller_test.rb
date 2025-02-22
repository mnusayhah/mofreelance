require "test_helper"

class Freelancer::MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get freelancer_messages_create_url
    assert_response :success
  end
end

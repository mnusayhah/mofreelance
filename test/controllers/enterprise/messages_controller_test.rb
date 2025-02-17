require "test_helper"

class Enterprise::MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get enterprise_messages_create_url
    assert_response :success
  end
end

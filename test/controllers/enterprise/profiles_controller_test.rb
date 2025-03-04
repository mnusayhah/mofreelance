require "test_helper"

class Enterprise::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get enterprise_profiles_new_url
    assert_response :success
  end
end

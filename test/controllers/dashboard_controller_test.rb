require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get company" do
    get dashboard_company_url
    assert_response :success
  end

  test "should get freelancer" do
    get dashboard_freelancer_url
    assert_response :success
  end
end

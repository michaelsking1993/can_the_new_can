require 'test_helper'

class CanTheCansControllerTest < ActionDispatch::IntegrationTest
  test "should get get_can_type" do
    get can_the_cans_get_can_type_url
    assert_response :success
  end

end

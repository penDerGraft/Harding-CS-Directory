require 'test_helper'

class StaicPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | Harding Computer Science Connect"
  end

end

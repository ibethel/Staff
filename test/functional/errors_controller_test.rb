require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get render_404" do
    get :render_404
    assert_response :success
  end

end

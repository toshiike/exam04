require 'test_helper'

class StudysheetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

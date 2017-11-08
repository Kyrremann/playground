require 'test_helper'

class MemoControllerTest < ActionDispatch::IntegrationTest
  test "should get overview" do
    get memo_overview_url
    assert_response :success
  end

end

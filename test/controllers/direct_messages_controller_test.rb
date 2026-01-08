require "test_helper"

class DirectMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get direct_messages_new_url
    assert_response :success
  end

  test "should get create" do
    get direct_messages_create_url
    assert_response :success
  end
end

require 'test_helper'

class GoogleControllerTest < ActionController::TestCase
  test "should get g_login" do
    get :g_login
    assert_response :success
  end

  test "should get g_logout" do
    get :g_logout
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get get_g_contacts" do
    get :get_g_contacts
    assert_response :success
  end

end

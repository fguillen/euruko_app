require 'test_helper'

class ReportersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reporters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reporter" do
    assert_difference('Reporter.count') do
      post :create, :reporter => { }
    end

    assert_redirected_to reporter_path(assigns(:reporter))
  end

  test "should show reporter" do
    get :show, :id => reporters(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reporters(:one).id
    assert_response :success
  end

  test "should update reporter" do
    put :update, :id => reporters(:one).id, :reporter => { }
    assert_redirected_to reporter_path(assigns(:reporter))
  end

  test "should destroy reporter" do
    assert_difference('Reporter.count', -1) do
      delete :destroy, :id => reporters(:one).id
    end

    assert_redirected_to reporters_path
  end
end

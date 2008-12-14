require File.dirname(__FILE__) + '/../test_helper'

class AttendsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attend" do
    assert_difference('Attend.count') do
      post :create, :attend => { }
    end

    assert_redirected_to attend_path(assigns(:attend))
  end

  test "should show attend" do
    get :show, :id => attends(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => attends(:one).id
    assert_response :success
  end

  test "should update attend" do
    put :update, :id => attends(:one).id, :attend => { }
    assert_redirected_to attend_path(assigns(:attend))
  end

  test "should destroy attend" do
    assert_difference('Attend.count', -1) do
      delete :destroy, :id => attends(:one).id
    end

    assert_redirected_to attends_path
  end
end

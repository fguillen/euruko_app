require 'test_helper'

class TriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create try" do
    assert_difference('Try.count') do
      post :create, :try => { }
    end

    assert_redirected_to try_path(assigns(:try))
  end

  test "should show try" do
    get :show, :id => tries(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tries(:one).id
    assert_response :success
  end

  test "should update try" do
    put :update, :id => tries(:one).id, :try => { }
    assert_redirected_to try_path(assigns(:try))
  end

  test "should destroy try" do
    assert_difference('Try.count', -1) do
      delete :destroy, :id => tries(:one).id
    end

    assert_redirected_to tries_path
  end
end

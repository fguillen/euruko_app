require File.dirname(__FILE__) + '/../test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post :create, :resource => { }
    end

    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should show resource" do
    get :show, :id => resources(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => resources(:one).id
    assert_response :success
  end

  test "should update resource" do
    put :update, :id => resources(:one).id, :resource => { }
    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should destroy resource" do
    assert_difference('Resource.count', -1) do
      delete :destroy, :id => resources(:one).id
    end

    assert_redirected_to resources_path
  end
end

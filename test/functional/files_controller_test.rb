require 'test_helper'

class FilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create file" do
    assert_difference('File.count') do
      post :create, :file => { }
    end

    assert_redirected_to file_path(assigns(:file))
  end

  test "should show file" do
    get :show, :id => files(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => files(:one).id
    assert_response :success
  end

  test "should update file" do
    put :update, :id => files(:one).id, :file => { }
    assert_redirected_to file_path(assigns(:file))
  end

  test "should destroy file" do
    assert_difference('File.count', -1) do
      delete :destroy, :id => files(:one).id
    end

    assert_redirected_to files_path
  end
end

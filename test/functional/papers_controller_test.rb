require 'test_helper'

class PapersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paper" do
    assert_difference('Paper.count') do
      post :create, :paper => { }
    end

    assert_redirected_to paper_path(assigns(:paper))
  end

  test "should show paper" do
    get :show, :id => papers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => papers(:one).id
    assert_response :success
  end

  test "should update paper" do
    put :update, :id => papers(:one).id, :paper => { }
    assert_redirected_to paper_path(assigns(:paper))
  end

  test "should destroy paper" do
    assert_difference('Paper.count', -1) do
      delete :destroy, :id => papers(:one).id
    end

    assert_redirected_to papers_path
  end
end

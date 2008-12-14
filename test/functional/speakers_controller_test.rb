require File.dirname(__FILE__) + '/../test_helper'

class SpeakersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:speakers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create speaker" do
    assert_difference('Speaker.count') do
      post :create, :speaker => { }
    end

    assert_redirected_to speaker_path(assigns(:speaker))
  end

  test "should show speaker" do
    get :show, :id => speakers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => speakers(:one).id
    assert_response :success
  end

  test "should update speaker" do
    put :update, :id => speakers(:one).id, :speaker => { }
    assert_redirected_to speaker_path(assigns(:speaker))
  end

  test "should destroy speaker" do
    assert_difference('Speaker.count', -1) do
      delete :destroy, :id => speakers(:one).id
    end

    assert_redirected_to speakers_path
  end
end

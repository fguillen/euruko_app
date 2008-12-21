require File.dirname(__FILE__) + '/../test_helper'

class RoomsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_room
    assert_difference('Room.count') do
      post :create, :room => { :name => 'room' }
    end

    assert_redirected_to room_path(assigns(:room))
  end

  def test_should_show_room
    get :show, :id => rooms(:room1).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => rooms(:room1).id
    assert_response :success
  end

  def test_should_update_room
    put :update, :id => rooms(:room1).id, :room => { }
    assert_redirected_to room_path(assigns(:room))
  end

  def test_should_destroy_room
    assert_difference('Room.count', -1) do
      delete :destroy, :id => rooms(:room2).id
    end

    assert_redirected_to rooms_path
  end
end

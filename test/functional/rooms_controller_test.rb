require File.dirname(__FILE__) + '/../test_helper'

class RoomsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms)
  end

  def test_on_get_with_admin_should_get_new
    login_as users(:user_admin)
    get :new
    assert_response :success
  end

  def test_on_get_with_logged_but_not_admin_should_response_404
    login_as users(:user1)
    get :new
    assert_response 404
  end

  def test_on_get_with_not_logged_should_redirect_new_session
    get :new
    assert_redirected_to new_session_path
  end

  def test_on_create_with_admin_should_create_room
    login_as users(:user_admin)
    assert_difference('Room.count') do
      post :create, :room => { :name => 'room' }
    end

    assert_not_nil( flash[:notice] )
    assert_redirected_to room_path(assigns(:room))
  end

  def test_on_create_with_not_admin_should_response_404
    login_as users(:user1)
    assert_difference('Room.count', 0) do
      post :create, :room => { :name => 'room' }
    end

    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_should_show_room
    get :show, :id => rooms(:room1).id
    assert_response :success
  end

  def test_on_get_with_admin_should_get_edit
    login_as users(:user_admin)
    get :edit, :id => rooms(:room1).id
    assert_response :success
  end

  def test_on_get_with_not_admin_should_response_404
    login_as users(:user1)
    get :edit, :id => rooms(:room1).id
    assert_response 404
  end

  def test_on_update_with_admin_should_update_room
    @room = rooms(:room1)
    login_as users(:user_admin)
    
    put :update, :id => @room.id, :room => { :name => 'other_name' }
    
    @room.reload
    assert_equal( 'other_name', @room.name)
    assert_not_nil( flash[:notice] )
    assert_redirected_to room_path(assigns(:room))
  end

  def test_on_update_with_not_admin_should_response_404
    @room = rooms(:room1)
    login_as users(:user1)
    put :update, :id => @room.id, :room => { :name => 'other_name' }
    
    @room.reload
    assert_not_equal( 'other_name', @room.name)
    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_on_destroy_with_admin_should_destroy_room
    login_as users(:user_admin)
    
    assert_difference('Room.count', -1) do
      delete :destroy, :id => rooms(:room2).id
    end

    assert_not_nil( flash[:notice] )
    assert_redirected_to rooms_path
  end
  
  def test_on_destroy_with_not_admin_should_response_404
    login_as users(:user1)
    
    assert_difference('Room.count', 0) do
      delete :destroy, :id => rooms(:room2).id
    end

    
    assert_nil( flash[:notice] )
    assert_response 404
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user
    assert_difference('User.count') do
      post(
        :create, 
        :user => {
          :name         => 'name',
          :login        => 'other_login',
          :email        => 'email@email.com',
          :password     => 'pass000',
          :password_confirmation => 'pass000',
          :role         => User::ROLE_USER
        }
      )
    end

    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_show_user
    get :show, :id => users(:user1).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => users(:user1).id
    assert_response :success
  end

  def test_should_update_user
    put :update, :id => users(:user1).id, :user => { :name => 'other name' }
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_destroy_user
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:user1).id
    end

    assert_redirected_to users_path
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_on_index_with_not_logged_should_get_only_public_users
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert( assigns(:users).include?( users(:user1) ) )
    assert( !assigns(:users).include?( users(:user2) ) )
  end

  def test_on_index_with_logged_but_not_admin_should_get_only_public_users
    login_as users(:user1)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert( assigns(:users).include?( users(:user1) ) )
    assert( !assigns(:users).include?( users(:user2) ) )
  end

  def test_on_index_with_logged_admin_should_get_all_users
    login_as users(:user_admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert( assigns(:users).include?( users(:user1) ) )
    assert( assigns(:users).include?( users(:user2) ) )
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
          :role         => User::ROLE[:USER],
          :public_profile => true
        }
      )
    end

    assert_redirected_to root_path
  end

  def test_should_create_user_with_public_profile_false
    assert_difference('User.count') do
      post(
        :create, 
        :user => {
          :name         => 'name',
          :login        => 'other_login',
          :email        => 'email@email.com',
          :password     => 'pass000',
          :password_confirmation => 'pass000',
          :role         => User::ROLE[:USER],
          :public_profile => false
        }
      )
    end
  end

  def test_on_show_with_not_logged_and_public_user_should_show_user
    get :show, :id => users(:user1).id
    assert_response :success
    assert_not_nil( assigns(:user) )
  end

  def test_on_show_with_not_logged_and_not_public_user_should_response_404
    get :show, :id => users(:user2).id
    assert_response 404
    assert_nil( assigns(:user) )
  end

  def test_on_show_with_logged_and_not_public_user_should_response_404
    login_as users(:user1)
    get :show, :id => users(:user2).id
    assert_response 404
    assert_nil( assigns(:user) )
  end

  def test_on_show_with_logged_and_not_public_user_but_same_user_should_show_user
    login_as users(:user2)
    get :show, :id => users(:user2).id
    assert_response :success
    assert_not_nil( assigns(:user) )
  end

  def test_on_show_with_admin_and_not_public_user_should_show_user
    login_as users(:user_admin)
    get :show, :id => users(:user2).id
    assert_response :success
    assert_not_nil( assigns(:user) )
  end

  def test_on_edit_when_logged_should_get_edit
    login_as users(:user1)
    get :edit, :id => users(:user1).id
    assert_response :success
  end

  def test_on_edit_when_not_logged_should_new_session
    get :edit, :id => users(:user1).id
    assert_not_nil( flash[:error] )
    assert_redirected_to new_session_path
  end

  def test_on_edit_when_logged_but_not_the_user_and_not_admin_should_404
    login_as users(:user1)
    get :edit, :id => users(:user2).id
    assert_response 404
  end

  def test_on_edit_when_logged_but_not_the_user_and_admin_should_success
    login_as users(:user_admin)
    get :edit, :id => users(:user1).id
    assert_response :success
  end

  def test_on_update_when_logger_should_update_user
    @user = users(:user1)
    login_as @user
    
    put(
      :update, 
      :id => @user.id, 
      :user => { :name => 'other name' }
    )
    
    @user.reload
    assert_not_nil( flash[:notice] )
    assert_equal( 'other name', @user.name )
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_on_update_when_logged_but_not_the_user_and_not_admin_should_404
    login_as users(:user1)
    
    put(
      :update, 
      :id => users(:user2).id, 
      :user => { :name => 'other name' }
    )
    
    assert_response 404
  end
  
  def test_on_update_when_logge_but_not_the_user_and_admin_should_update
    @user = users(:user1)
    login_as users(:user_admin)
    
    put(
      :update, 
      :id => @user.id, 
      :user => { :name => 'other name' }
    )
    
    @user.reload
    assert_not_nil( flash[:notice] )
    assert_equal( 'other name', @user.name )
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_when_search_speakers_only_assings_speakers
    get :index, :speakers => true
    
    assert_not_nil( assigns(:users) )
    assert( assigns(:users).include?( users(:user1) ) )
    assert( !assigns(:users).include?( users(:user2) ) )
  end
  
  def test_correct_site_name_on_user_create_email
    ActionMailer::Base.deliveries = []
    
    post(
      :create, 
      :user => {
        :name         => 'name',
        :login        => 'other_login',
        :email        => 'email@email.com',
        :password     => 'pass000',
        :password_confirmation => 'pass000',
        :role         => User::ROLE[:USER],
        :public_profile => true
      }
    )
    
    assert !ActionMailer::Base.deliveries.empty?
    sent = ActionMailer::Base.deliveries.last
        
    # puts sent
    
    assert( sent.subject =~ /\[EuRuKo_test\]/ )
  end
  
  def test_correct_site_name_on_user_create_email
    @user = users(:user_not_actived)
    assert( !@user.active? )
    ActionMailer::Base.deliveries = []
    
    get(
      :activate,
      :activation_code => @user.activation_code
    )
    
    assert !ActionMailer::Base.deliveries.empty?
    sent = ActionMailer::Base.deliveries.last
        
    # puts sent
    
    assert( sent.subject =~ /\[EuRuKo_test\]/ )
  end
end

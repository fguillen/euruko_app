require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_on_index_with_not_logged_should_get_only_public_users
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert( assigns(:users).include?( users(:user1) ) )
    assert( !assigns(:users).include?( users(:private) ) )
  end

  def test_on_index_with_logged_but_not_admin_should_get_only_public_users
    login_as users(:user1)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert( assigns(:users).include?( users(:user1) ) )
    assert( !assigns(:users).include?( users(:private) ) )
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
    get :show, :id => users(:private).id
    assert_response 404
    assert_nil( assigns(:user) )
  end

  def test_on_show_with_logged_and_not_public_user_should_response_404
    login_as users(:user1)
    get :show, :id => users(:private).id
    assert_response 404
    assert_nil( assigns(:user) )
  end

  def test_on_show_with_logged_and_not_public_user_but_same_user_should_show_user
    login_as users(:private)
    get :show, :id => users(:private).id
    assert_response :success
    assert_not_nil( assigns(:user) )
  end

  def test_on_show_with_admin_and_not_public_user_should_show_user
    login_as users(:user_admin)
    get :show, :id => users(:private).id
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
  
  def test_on_update_when_logged_but_not_the_user_and_admin_should_update
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
    get :index, :search => 'speakers'
    
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
  
  def test_autologin_after_successful_signup
    @user = users(:user_not_actived)
    assert( !@user.active? )
    get :activate, :activation_code => @user.activation_code
    assert @user.reload.active?
    assert_equal @user, assigns['current_user']
    assert_redirected_to '/'
  end
  
  def test_forgot_password_shows_email_form
    get :forgot_password
    assert_response :success
    assert_select "form[action=#{forgot_password_path}]"
    assert_select "input[name=email]"
  end
  
  def test_forgot_password_sends_email_with_reset_link_to_valid_emails
    UserMailer.expects(:deliver_forgotten_password).once
    @user = users(:user1)
    post :forgot_password, :email => @user.email
    assert_redirected_to login_path
  end
  
  def test_forgotten_password_not_sent_invalid_emails_and_shows_form_again
    UserMailer.expects(:deliver_forgotten_password).never
    post :forgot_password, :email => 'bad@email.com'
    assert_select "form[action=#{forgot_password_path}]"
    assert_select "input[name=email]"
  end
  
  def test_forgot_password_not_sent_if_user_not_activated_and_shows_form_again
    UserMailer.expects(:deliver_forgotten_password).never
    post :forgot_password, :email => users(:user_not_actived).email
    assert_select "form[action=#{forgot_password_path}]"
    assert_select "input[name=email]"
  end

  def test_reset_password_with_invalid_code
    get :reset_password, :id => 'bad_code'
    assert_response 404
  end

  def test_reset_password_with_valid_code_shows_password_form
    @user = users(:user1)
    @user.forgot_password
    get :reset_password, :id => @user.password_reset_code
    assert_equal @user.id, assigns(:user).id
    assert_select "form[action=#{reset_password_path}]"
    assert_select "input[name=password]"
    assert_select "input[name=password_confirmation]"
  end
  
  def test_reset_password_with_valid_code_should_reset_password_reset_code
    @user = users(:user1)
    assert_nil( @user.password_reset_code )
    
    @user.forgot_password
    
    assert_not_nil( @user.password_reset_code )
    
    post(
      :reset_password, 
      :id => @user.password_reset_code, 
      :password => 'new password', 
      :password_confirmation => 'new password'
    )

    @user.reload
    assert_nil( @user.password_reset_code )
  end
  
  def test_reset_password_with_valid_password_and_confirmation
    @user = users(:user1)
    old_pwd = @user.crypted_password
    @user.forgot_password
    post :reset_password, :id => @user.password_reset_code, :password => 'new password', :password_confirmation => 'new password'
    assert_not_equal( old_pwd, @user.reload.crypted_password )
    assert_not_nil( flash[:notice] )
    assert_redirected_to login_path
  end
  
  def test_reset_password_with_invalid_password_shows_form_and_error
    @user = users(:user1)
    old_pwd = @user.crypted_password
    @user.forgot_password
    post :reset_password, :id => @user.password_reset_code, :password => 'abc', :password_confirmation => 'abc'
    assert_response :success
    assert_select "form[action=#{reset_password_path}]"
    assert_select "input[name=password]"
    assert_select "input[name=password_confirmation]"
  end
  
  def test_reset_password_with_invalid_confirmation_shows_form_and_error
    @user = users(:user1)
    old_pwd = @user.crypted_password
    @user.forgot_password
    post :reset_password, :id => @user.password_reset_code, :password => 'new password', :password_confirmation => 'different password'
    assert_response :success
    assert_select "form[action=#{reset_password_path}]"
    assert_select "input[name=password]"
    assert_select "input[name=password_confirmation]"
  end
  
  def test_on_index_with_xml_format_should_not_share_private_attributes
    get(
      :show,
      :id     => users(:user1).id,
      :format => 'xml'
    )
    assert_response :success
    assert_nil( @response.body =~ /email/ )
    assert_nil( @response.body =~ /password/ )
    assert_not_nil( @response.body =~ /text/ )
  end
  
  def test_on_show_with_xml_format_should_not_share_private_attributes
    get :index, :format => 'xml'
    assert_response :success
    assert_nil( @response.body =~ /email/ )
    assert_nil( @response.body =~ /password/ )
    assert_not_nil( @response.body =~ /text/ )
  end
  
  def test_on_index_should_not_show_not_activated_users
    get :index
    assert( !assigns(:users).include?( users(:user_not_actived) ) )
  end
  
  def test_on_update_with_not_admin_should_not_update_role
    @user = users(:user1)
    login_as @user
    
    post(
      :update,
      :id   => @user.id,
      :user => { :role => User::ROLE[:ADMIN] }
    )
    
    @user.reload
    assert_equal( User::ROLE[:USER], @user.role)
  end
  
  def test_on_update_with_admin_should_update_role
    @user = users(:user1)
    login_as users(:user_admin)
    
    post(
      :update,
      :id   => @user.id,
      :user => { :role => User::ROLE[:ADMIN] }
    )
    
    @user.reload
    assert_equal( User::ROLE[:ADMIN], @user.role)
  end
  
  def test_on_index_with_paginate
    get :index, :page => 1
    assert_response :success
    assert_not_nil assigns(:users)
    assert( assigns(:users).include?( users(:user1) ) )
    assert( !assigns(:users).include?( users(:private) ) )
    
    get :index, :page => 2
    assert_response :success
    assert_not_nil assigns(:users)
    assert assigns(:users).empty?
  end
  
  def test_on_update_can_update_password
    @user = users(:user1)
    login_as @user
    
    assert( !@user.authenticated?( 'newpassword' ) )
    
    post(
      :update,
      :id => @user.id,
      :user => {
        :change_password        => '1',
        :password               => 'newpassword',
        :password_confirmation  => 'newpassword'
      }
    )
    
    @user.reload
    assert( @user.authenticated?( 'newpassword' ) )
  end
  
  def test_on_update_not_change_password_if_not_change_password_setted
    @user = users(:user1)
    login_as @user
    
    assert( !@user.authenticated?( 'newpassword' ) )
    
    post(
      :update,
      :id => @user.id,
      :user => {
        :change_password        => '0',
        :password               => 'newpassword',
        :password_confirmation  => 'newpassword'
      }
    )
    
    @user.reload
    assert( !@user.authenticated?( 'newpassword' ) )
  end
  
  def test_on_update_if_not_change_password_setted_should_delete_password_fields
    @user = users(:user1)
    login_as @user
    
    assert( !@user.authenticated?( 'newpassword' ) )
    
    post(
      :update,
      :id => @user.id,
      :user => {
        :change_password        => '0',
        :password               => 'newpassword'
      }
    )
    
    @user.reload
    assert( !@user.authenticated?( 'newpassword' ) )
  end
  
  def test_on_index_with_search_atteendes
    get(
      :index,
      :search     => 'event_attendees',
      :event_id   => events(:event1).id
    )
    
    assert_response :success
    assert_equal( 2, assigns(:users).size )
    assert( assigns(:users).include?( users(:user1 ) ) )
    assert( assigns(:users).include?( users(:user_everything_paid ) ) )
  end
  
  def test_on_reset_password_if_code_null_should_response_404
    get :reset_password
    assert_response 404
  end
  
  def test_on_update_invoice_info
    @user = users(:user1)
    login_as @user
    
    put(
      :update, 
      :id => @user.id, 
      :user => { :invoice_info => 'other invoice info' }
    )
    
    @user.reload
    assert_not_nil( flash[:notice] )
    assert_equal( 'other invoice info', @user.invoice_info )
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_on_index_with_not_user_with_csv_format
    get(
      :index,
      :format => 'csv'
    )

    assert_response :success
    assert_match( /#{users(:user1).name}/, @response.body )
    assert_no_match( /#{users(:user1).email}/, @response.body )
  end
  
  def test_on_index_with_valid_user_with_csv_format
    login_as users(:user1)

    get(
      :index,
      :format => 'csv'
    )

    assert_response :success
    assert_match( /#{users(:user1).name}/, @response.body )
    assert_no_match( /#{users(:user1).email}/, @response.body )
  end
  
  def test_on_index_with_admin_user_with_csv_format
    login_as users(:user_admin)

    get(
      :index,
      :format => 'csv'
    )

    assert_response :success
    assert_match( /#{users(:user1).name}/, @response.body )
    assert_match( /#{users(:user1).email}/, @response.body )
  end
  
  def test_on_index_with_pdf_format
    get(
      :index,
      :format => 'pdf'
    )

    assert_response :success
    assert_equal( 'application/pdf', @response.content_type )
  end
end

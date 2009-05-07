require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:static_pages)
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

  def test_on_create_with_admin_should_create_static_page
    login_as users(:user_admin)
    assert_difference('StaticPage.count') do
      post(
        :create, 
        :static_page => { 
          :title => 'static_page',
          :content => 'static_page content',
          :permalink => 'static_page_permalink'
        }
      )
    end

    assert_not_nil( flash[:notice] )
    assert_redirected_to static_page_path(assigns(:static_page))
  end

  def test_on_create_with_not_admin_should_response_404
    login_as users(:user1)
    assert_difference('StaticPage.count', 0) do
      post(
        :create, 
        :static_page => { 
          :title => 'static_page',
          :content => 'static_page content',
          :permalink => 'static_page permalink'
        }
      )
    end

    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_should_show_static_page
    get :show, :id => static_pages(:static_page1).permalink
    assert_response :success
  end

  def test_on_get_with_admin_should_get_edit
    login_as users(:user_admin)
    get :edit, :id => static_pages(:static_page1).permalink
    assert_response :success
  end

  def test_on_get_with_not_admin_should_response_404
    login_as users(:user1)
    get :edit, :id => static_pages(:static_page1).permalink
    assert_response 404
  end

  def test_on_update_with_admin_should_update_static_page
    @static_page = static_pages(:static_page1)
    login_as users(:user_admin)
    
    put :update, :id => @static_page.permalink, :static_page => { :title => 'other_title' }
    
    @static_page.reload
    assert_equal( 'other_title', @static_page.title)
    assert_not_nil( flash[:notice] )
    assert_redirected_to static_page_path(assigns(:static_page))
  end

  def test_on_update_with_not_admin_should_response_404
    @static_page = static_pages(:static_page1)
    login_as users(:user1)
    put :update, :id => @static_page.permalink, :static_page => { :title => 'other_title' }
    
    @static_page.reload
    assert_not_equal( 'other_title', @static_page.title)
    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_on_destroy_with_admin_should_destroy_static_page
    login_as users(:user_admin)
    
    assert_difference('StaticPage.count', -1) do
      delete :destroy, :id => static_pages(:static_page1).permalink
    end

    assert_not_nil( flash[:notice] )
    assert_redirected_to static_pages_path
  end
  
  def test_on_destroy_with_not_admin_should_response_404
    login_as users(:user1)
    
    assert_difference('StaticPage.count', 0) do
      delete :destroy, :id => static_pages(:static_page1).permalink
    end

    
    assert_nil( flash[:notice] )
    assert_response 404
  end

end

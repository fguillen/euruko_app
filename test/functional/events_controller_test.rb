require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  def test_on_new_with_admin_should_get_new
    login_as users(:user_admin)
    get :new
    assert_response :success
  end

  def test_on_new_with_not_logged_should_redirect_to_new_session
    get :new
    assert_redirected_to new_session_path
  end

  def test_on_new_with_logged_but_not_admin_should_response_404
    login_as users(:user1)
    get :new
    assert_response 404
  end

  def test_on_create_with_admin_should_create_event
    login_as users(:user_admin)
    
    assert_difference('Event.count') do
      post :create, :event => { :name => 'name', :description => 'description', :price_cents => 1 }
    end

    assert_redirected_to event_path(assigns(:event))
  end
  
  def test_on_create_with_not_logged_should_redirect_to_new_session
    assert_difference('Event.count', 0) do
      post :create, :event => { :name => 'name', :description => 'description', :price_cents => 1 }
    end

    assert_redirected_to new_session_path
  end

  def test_on_create_with_logged_but_not_admin_should_response_404
    login_as users(:user1)
    
    assert_difference('Event.count', 0) do
      post :create, :event => { :name => 'name', :description => 'description', :price_cents => 1 }
    end

    assert_response 404
  end

  def test_should_show_event
    get :show, :id => events(:event1).id
    assert_response :success
  end

  def test_on_edit_with_admin_should_get_edit
    login_as users(:user_admin)
    
    get :edit, :id => events(:event1).id
    assert_response :success
  end

  def test_on_edit_with_not_logged_should_redirecto_to_new_session
    get :edit, :id => events(:event1).id
    assert_redirected_to new_session_path
  end

  def test_on_edit_with_logged_but_not_admin_should_response_404
    login_as users(:user1)
    get :edit, :id => events(:event1).id
    assert_response 404
  end

  def test_on_update_with_admin_should_update_event
    @event = events(:event1)
    login_as users(:user_admin)
    
    put(
      :update, 
      :id => @event.id, 
      :event => { 
        :name         => 'other name',
        :price_cents  => '123',
        :capacity     => '321'
      }
    )
    
    @event.reload
    assert_equal( 'other name', @event.name )
    assert_equal( 123, @event.price_cents )
    assert_equal( 321, @event.capacity )
    assert_not_nil( flash[:notice] )
    assert_redirected_to event_path(assigns(:event))
  end

  def test_on_update_with_not_logged_should_redirect_to_new_session
    put :update, :id => events(:event1).id, :event => { :name => 'other name' }
    
    assert_redirected_to new_session_path
  end

  def test_on_update_with_logged_should_response_404
    @event = events(:event1)
    login_as users(:user1)
    
    put :update, :id => @event.id, :event => { :name => 'other name' }
    
    @event.reload
    assert_not_equal( 'other name', @event.name )
    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_on_destroy_with_admin_should_destroy_event
    login_as users(:user_admin)
    
    events(:event3).carts.destroy_all
    
    assert_difference('Event.count', -1) do
      delete :destroy, :id => events(:event3).id
    end

    assert_redirected_to events_path
  end
  
  def test_on_destroy_not_logged_should_redirect_to_new_session
    assert_difference('Event.count', 0) do
      delete :destroy, :id => events(:event2).id
    end

    assert_redirected_to new_session_path
  end
  
  def test_on_destroy_with_logged_but_not_admin_should_response_404
    login_as users(:user1)
    
    assert_difference('Event.count', 0) do
      delete :destroy, :id => events(:event2).id
    end

    assert_response 404
  end

end

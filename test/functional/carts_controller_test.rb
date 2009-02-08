require File.dirname(__FILE__) + '/../test_helper'

class CartsControllerTest < ActionController::TestCase
  
  def test_on_new_when_user_logged_should_return_current_cart
    login_as users(:user1)
    
    get :new
    
    assert_not_nil( assigns(:cart) )
  end
  
  def test_on_new_when_not_user_logged_should_return_new_session
    get :new
    
    assert_redirected_to new_session_path
  end
  
  def test_on_new_when_admin_logged_should_return_expecified_cart
    login_as users(:user_admin)
    
    get :new, :id => carts(:cart_user1_event1_purchased).id
    
    assert_not_nil( assigns(:cart) )
    assert_equal( carts(:cart_user1_event1_purchased), assigns(:cart) )
  end
  
  def test_on_confirm_with_user_logged_should_add_events_to_current_cart
    login_as users(:user1)    
    @cart = carts(:cart_user1_empty_and_not_purchased)
    load_current_cart @cart
    
    assert_difference "CartsEvent.count", 2 do
      post(
        :confirm,
        :event_ids => [events(:event1).id, events(:event2).id]
      )
    end    
    
    assert_equal( 2, @cart.events.count )
  end
  
  def test_on_confirm_with_user_logged_but_not_events_should_empty_the_cart_and_redirect_to_new_again
    login_as users(:user1)
    @cart = carts(:cart_user1_event2_not_purchased)
    load_current_cart @cart
    
    assert( !@cart.events.empty? )
    
    post( :confirm )
    
    assert( @cart.events.empty? )    
    assert_not_nil( flash[:error] )
    assert_redirected_to new_cart_path
  end

  def test_on_confirm_with_user_not_logged_should_redirected_to_new_session
    post( :confirm )
    assert_redirected_to new_session_path
  end

  
  def test_on_notificate_with_good_params_should_update_the_cart
    @cart = carts(:cart_user1_event2_not_purchased)
    
    assert( !@cart.is_purchased? )
    assert( !events(:event2).is_paid_for_user?( users(:user1).id ) )
    
    post(
      :notificate,
      :invoice          => @cart.id,
      :payment_status   => Cart::STATUS[:COMPLETED],
      :secret           => APP_CONFIG[:paypal_secret],
      :receiver_email   => APP_CONFIG[:paypal_seller],
      :mc_gross         => @cart.total_price_on_euros,
      :mc_currency      => 'EUR',
      :txn_id           => 1
    )

    @cart.reload
    # puts @cart.paypal_errors
    
    assert( @cart.is_purchased? )
    assert( events(:event2).is_paid_for_user?( users(:user1).id ) )
    
    assert_not_nil( @cart.paypal_notify_params )
    assert_equal( Cart::STATUS[:COMPLETED], @cart.paypal_status )
    assert_equal( Cart::STATUS[:COMPLETED], @cart.status )
    assert_equal( '1', @cart.transaction_id )
    
    assert_response :success
  end
  
  def test_on_notificate_with_status_not_completed_should_update_the_cart_but_the_events_will_not_paid
    @cart = carts(:cart_user1_event2_not_purchased)
    
    assert( !@cart.is_purchased? )
    assert( !events(:event2).is_paid_for_user?( users(:user1).id ) )
    
    post(
      :notificate,
      :invoice => @cart.id,
      :payment_status => 'ERROR',
      :txn_id => 1
    )

    @cart.reload
    assert( !@cart.is_purchased? )
    assert( !events(:event2).is_paid_for_user?( users(:user1).id ) )
    
    assert_not_nil( @cart.paypal_notify_params )
    assert_equal( 'ERROR', @cart.paypal_status )
    assert_equal( '1', @cart.transaction_id )
    
    assert_response :success
  end
  
  def test_on_notificate_with_not_valid_cart_id_should_respond_404
    post(
      :notificate,
      :invoice => -1,
      :payment_status => 'Completed',
      :txn_id => 1
    )
    
    assert_response 404
  end

  def test_on_complete_when_user_logged_and_cart_completed_should_flash_notice
    login_as users(:user1)
    @cart = carts(:cart_user1_event1_purchased)
    
    get(
      :complete,
      :invoice => @cart.id
    )
    
    @cart.reload
    assert_not_nil( @cart.paypal_complete_params )
    assert_not_nil( flash[:notice] )
    assert_response :success
  end
  
  def test_on_complete_when_user_logged_and_cart_not_completed_should_flash_error
    login_as users(:user1)
      
    get(
      :complete,
      :invoice => carts(:cart_user1_event2_not_purchased).id
    )
    
    assert_not_nil( flash[:error] )
    assert_response :success
  end
  
  def test_on_complete_when_user_logged_and_invoice_id_not_valid_should_response_404
    login_as users(:user1)
      
    get(
      :complete,
      :invoice => -1
    )
    
    assert_response 404
  end
  
  def test_on_complete_when_user_logged_but_not_the_owner_of_the_cart_should_response_404
    login_as users(:user2)
      
    get(
      :complete,
      :invoice => carts(:cart_user1_event2_not_purchased).id
    )
    
    assert_response 404
  end
  
  def test_initialize_cart_if_current_cart_is_not_owned_for_user_logged
    login_as users(:user2)
    load_current_cart carts(:cart_user1_event2_not_purchased)

    assert_equal( carts(:cart_user1_event2_not_purchased), retrieve_current_cart )
    assert_not_equal( retrieve_current_cart.user, users(:user2) )
    
    get :new
    
    assert_not_equal( carts(:cart_user1_event2_not_purchased), retrieve_current_cart )
    assert_equal( retrieve_current_cart.user, users(:user2) )
    assert_equal( retrieve_current_cart, assigns(:cart) )
  end
    
    
  def test_on_complete_update_status_to_not_notified_if_still_on_session
    login_as users(:user1)
    
    @cart = carts(:cart_user1_event2_not_purchased)
      
    get(
      :complete,
      :invoice => @cart.id
    )

    @cart.reload
    assert_equal( Cart::STATUS[:NOT_NOTIFIED], @cart.status )
    assert_not_nil( flash[:error] )
    assert_response :success
  end
end
require File.dirname(__FILE__) + '/../test_helper'

class CartTest < ActiveSupport::TestCase
  def test_total_price
    @cart = carts(:cart_user1_event1_purchased)
    assert( @cart.total_price )
    assert_equal( events(:event1).price_cents, @cart.total_price )
    
    @cart.events << events(:event2)
    assert_equal( events(:event1).price_cents + events(:event2).price_cents, @cart.total_price )
  end
  
  def test_total_on_euros
    @cart = carts(:cart_user1_event1_purchased)
    assert( @cart.total_price_on_euros )
    assert_equal( events(:event1).price_euros, @cart.total_price_on_euros )
  end
  
  def test_one_cart_should_doesnot_have_the_same_event_twice
    @cart = carts(:cart_user1_event1_purchased)
    assert_raise(ActiveRecord::StatementInvalid) do
      @cart.events << events(:event1)
    end
  end
    
  def test_on_create_should_initialize_status
    @cart = users(:user1).carts.create!
    assert( @cart.valid? )
    assert_equal( Cart::STATUS[:ON_SESSION], @cart.status )
  end
  
  def test_paypal_url
    assert( carts(:cart_user1_event1_purchased).paypal_encrypted( 'return_url', 'notify_url' ) )
    # puts carts(:cart_user1_event1_purchased).paypal_url( 'return_url', 'notify_url' )
  end
  
  def test_is_purchased
    assert( carts(:cart_user1_event1_purchased).is_purchased? )
    assert( !carts(:cart_user1_event2_not_purchased).is_purchased? )
  end
  
  def test_name_scope_purchased
    assert( Cart.purchased.include?( carts(:cart_user1_event1_purchased) ) )
    assert( !Cart.purchased.include?( carts(:cart_user1_event2_not_purchased) ) )
  end
  
  def test_encrypt_for_paypal
    assert( Cart.encrypt_for_paypal( "texto" ) )
  end
  
  def test_paypal_notificate
    @cart = carts(:cart_user1_event1_purchased)
    @cart.paypal_notificate( {:payment_status => Cart::STATUS[:COMPLETED] } )
    assert_equal( Cart::STATUS[:PAYPAL_ERROR], @cart.status )
  end
  
  def test_events_out_of_capacity
    @event = events(:event1)
    @cart = Cart.create!( :user => users(:user1) )
    @cart.events << @event
    
    assert( @cart.events_out_of_capacity.empty? )
    
    @event.update_attribute( :capacity, 0 )
    @cart.reload
    
    assert_equal( [@event], @cart.events_out_of_capacity )
  end
  
  def test_on_paypal_notificate_should_send_email_notifications
    @cart = carts(:cart_user1_event1_purchased)
    
    @cart.expects(:send_email_notifications).once
    
    @cart.paypal_notificate( {} )
  end
  
  def test_send_email_notifications_ok_when_is_completed
    ActionMailer::Base.deliveries = []
    
    @cart = carts(:cart_user1_event1_purchased)
    @cart.status = Cart::STATUS[:COMPLETED]
    @cart.send_email_notifications
    
    assert !ActionMailer::Base.deliveries.empty?
    to_user = ActionMailer::Base.deliveries[0]
    to_admin = ActionMailer::Base.deliveries[1]
    
    assert( to_user.subject.include?( "Payment received!" ) )
    assert( to_user.body.include?( @cart.events[0].name ) )
    assert( to_user.body.include?( @cart.id.to_s ) )
    assert_equal( @cart.user.email.to_a, to_user.to )

    assert( to_admin.subject.include?( "New purchase, id: #{@cart.id}" ) )
    assert( to_admin.body.include?( @cart.events[0].name ) )
    assert( to_admin.body.include?( @cart.id.to_s ) )
    assert_equal( APP_CONFIG[:email_notification_recipients], to_admin.to )
  end
  
  def test_send_email_notifications_error_when_is_not_completed
    ActionMailer::Base.deliveries = []
    
    @cart = carts(:cart_user1_event1_purchased)
    @cart.status = Cart::STATUS[:PAYPAL_ERROR]
    @cart.send_email_notifications
    
    assert !ActionMailer::Base.deliveries.empty?
    to_user = ActionMailer::Base.deliveries[0]
    to_admin = ActionMailer::Base.deliveries[1]

    assert( to_user.subject.include?( "Some errors found at the purchase!" ) )
    assert( to_user.body.include?( @cart.id.to_s ) )
    assert_equal( @cart.user.email.to_a, to_user.to )

    assert( to_admin.subject.include?( "Some errors found at the purchase, id: #{@cart.id}" ) )
    assert( to_admin.body.include?( @cart.id.to_s ) )
    assert_equal( APP_CONFIG[:email_notification_recipients], to_admin.to )
  end
  
  def test_send_twitter_notifications
    TwitterWrapper.expects(:post).with( 'Only 8 places available on Event 1' ).once
    
    @cart = carts(:cart_user1_event1_purchased)
    @cart.status = Cart::STATUS[:COMPLETED]
    
    @cart.send_twitter_notifications
  end
  
  def test_send_twitter_notifications_with_sold_out
    TwitterWrapper.expects(:post).with( 'Event 1 SOLD OUT!' ).once
    
    @event = events(:event1)
    @event.update_attribute(:capacity, 0)
    
    @cart = carts(:cart_user1_event1_purchased)
    @cart.status = Cart::STATUS[:COMPLETED]
    
    @cart.send_twitter_notifications
  end
  
end
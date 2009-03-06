require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
  end

  def test_relations
    assert_equal( 2, events(:event1).carts.size )
  end

  def test_create
    assert_difference "Event.count", 1 do
      Event.create(
        :name => 'event', 
        :description => 'description'
      )
    end
  end
  
  def test_permalink
    @event = 
      Event.create(
        :name => 'event', 
        :description => 'description'
      )      
      
    assert( @event.valid? )
    assert_not_nil( @event.permalink )
    assert_equal( @event.id, @event.to_param.to_i )
  end

  def test_destroy_with_payments_should_raise_exception
    assert_raise(NotDeletableEventException) do
      events(:event1).destroy
    end
  end


  def test_destroy_without_payments
    @event = Event.create(:name => 'event', :description => 'description')
    
    assert_difference "Event.count", -1 do
      @event.destroy
    end
  end

  def test_foreign_keys
  end

  def test_validations
    event = Event.new()
    assert( !event.valid? )
    assert( event.errors.on(:name) )
    assert( event.errors.on(:description) )
    
    event = Event.new(:name => 'event', :description => 'description')
    assert( event.valid? )
  end
  

  
  def test_is_paid_for_user
    assert( events(:event1).is_paid_for_user?( users(:user1) ) )
    assert( !events(:event2).is_paid_for_user?( users(:user1) ) )
    assert( !events(:event1).is_paid_for_user?( users(:user2) ) )
  end
  
  def test_price_cents
    assert_equal( "1.00", events(:event1).price_euros )
    assert_equal( "2.00", events(:event2).price_euros )
  end
  
  def test_count_purchases
    @event = 
      Event.create!(
        :name => 'event', 
        :description => 'description'
      )
      
    assert_equal( 0, @event.count_purchases )
    
    @cart = Cart.create!( :user => users(:user1) )
    @cart.events << @event
    @cart.reload

    assert_equal( 0, @event.count_purchases )
    
    @cart.update_attribute( :status, Cart::STATUS[:COMPLETED] )
    
    assert_equal( 1, @event.count_purchases )
  end

  def test_count_purchases
    @event = 
      Event.create!(
        :name         => 'event', 
        :description  => 'description',
        :capacity     => 10
      )
      
    assert_equal( 10, @event.remaining_capacity )
    
    @cart = Cart.create!( :user => users(:user1) )
    @cart.events << @event
    @cart.reload

    assert_equal( 10, @event.remaining_capacity )
    
    @cart.update_attribute( :status, Cart::STATUS[:COMPLETED] )
    
    assert_equal( 9, @event.remaining_capacity )
  end
end

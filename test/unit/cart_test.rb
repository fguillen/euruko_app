require File.dirname(__FILE__) + '/../test_helper'

class CartTest < ActiveSupport::TestCase
  def test_total_price
    @cart = carts(:cart_user1_event1_purchased)
    assert( @cart.total_price )
    assert_equal( events(:event1).price_cents, @cart.total_price )
    
    @cart.events << events(:event2)
    assert_equal( events(:event1).price_cents + events(:event2).price_cents, @cart.total_price )
  end
  
  def test_one_cart_should_doesnot_have_the_same_event_twice
    @cart = carts(:cart_user1_event1_purchased)
    assert_raise(ActiveRecord::StatementInvalid) do
      @cart.events << events(:event1)
    end
  end
  
  
end
require File.dirname(__FILE__) + '/../test_helper'

class CartTest < ActiveSupport::TestCase
  def test_total_price
    # @event01 = events(:event1)
    # @event02 = events(:event2)
    
    assert( carts(:cart_user1_event1_purchased).total_price )
    # assert_equal( @event01.price_cents + @event02.price_cents, Event.total_price( [@event01, @event02] ) )
  end
end
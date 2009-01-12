require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:event1)
  end

  def test_relations
    assert_equal( 1, @event.payments.size )
  end

  def test_create
    assert_difference "Event.count", 1 do
      Event.create(:name => 'event', :description => 'description')
    end
  end

  def test_destroy_with_payments_should_raise_exception
    assert_raise(NotDeletableEventException) do
      @event.destroy
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
  
  def test_total_price
    @event01 = events(:event1)
    @event02 = events(:event2)
    
    assert( Event.total_price( [@event01, @event02] ) )
    assert_equal( @event01.price_cents + @event02.price_cents, Event.total_price( [@event01, @event02] ) )
  end

end

require File.dirname(__FILE__) + '/../test_helper'

class RoomTest < ActiveSupport::TestCase
  def setup
    @room = rooms(:room1)
    @paper = papers(:paper1)
  end

  def test_relations
    assert_equal( @room, @paper.room )
  end

  def test_create
    assert_difference "Room.count", 1 do
      Room.create(:name => 'room')
    end
  end

  def test_validations
    room = Room.new()
    assert( !room.valid? )
    assert( room.errors.on(:name) )
    
    room = Room.new(:name => 'room')
    assert( room.valid? )
  end
end

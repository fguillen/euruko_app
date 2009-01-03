require File.dirname(__FILE__) + '/../test_helper'

class AttendeeTest < ActiveSupport::TestCase
  
  def setup
    @attendee = attendees(:user1_go_paper1)
    @user = users(:user1)
    @paper = papers(:paper1)
  end
  
  def test_relations
    assert_equal( @user, @attendee.user )
    assert_equal( @paper, @attendee.paper )
  end
  
  def test_create
    assert_difference "Attendee.count", 1 do
      Attendee.create(:user => @user, :paper => papers(:paper2))
    end
  end
  
  def test_destroy
    assert_difference "Attendee.count", -1 do
      @attendee.destroy
    end
  end
  
  def test_uniqueness
    assert_difference "Attendee.count", 0 do
      Attendee.create(
        :user     => @user,
        :paper    => @paper
      )
    end
  end
  
  def test_validations
    attendee = Attendee.new(:paper => @paper)
    assert( !attendee.valid? )
    assert( attendee.errors.on(:user_id) )
    assert( !attendee.errors.on(:paper_id) )
    
    attendee = Attendee.new(:user => @user)
    assert( !attendee.valid? )
    assert( !attendee.errors.on(:user_id) )
    assert( attendee.errors.on(:paper_id) )

    attendee = Attendee.new(:user => @user, :paper => @paper)
    assert( !attendee.valid? )
    assert( !attendee.errors.on(:user_id) )
    assert( attendee.errors.on(:paper_id) )
    
    attendee = Attendee.new(:user => @user, :paper => papers(:paper2))
    assert( attendee.valid? )
  end
end

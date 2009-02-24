require File.dirname(__FILE__) + '/../test_helper'


class VoteTest < ActiveSupport::TestCase
  def setup
    @vote = votes(:vote1)
    @user = users(:user1)
    @paper = papers(:paper1)
  end

  def test_relations
    assert_equal( @user, @vote.user )
    assert_equal( @paper, @vote.paper )
  end

  def test_create
    assert_difference "Vote.count", 1 do
      Vote.create(
        :user => @user, 
        :paper => papers(:paper2), 
        :points => 2
      )
    end
  end

  def test_destroy
    assert_difference "Vote.count", -1 do
      @vote.destroy
    end
  end
  
  def test_uniqueness
    assert_difference "Attendee.count", 0 do
      Vote.create(
        :user     => @vote.user,
        :paper    => @vote.paper
      )
    end
  end

  def test_validations
    vote = Vote.new()
    assert( !vote.valid? )
    assert( vote.errors.on(:user_id) )
    assert( vote.errors.on(:paper_id) )
    assert( vote.errors.on(:points) )

    vote = Vote.new(:user => @user, :paper => papers(:paper2), :points => 2)
    assert( vote.valid? )
    
    vote.points = 0
    assert( !vote.valid? )
    assert( vote.errors.on(:points) )
    
    vote.points = 6
    assert( !vote.valid? )
    assert( vote.errors.on(:points) )
  end
end

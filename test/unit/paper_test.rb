require File.dirname(__FILE__) + '/../test_helper'

# has_many :speakers
# has_many :user_speakers, :through => :speakers, :source => :user
# has_many :comments
# has_many :resources
# has_many :attendees
# has_many :attendees, :through => :attendees, :source => :user
# 
# belongs_to :room

# t.string      :title, :null => false, :limit => 255
# t.text        :description
# t.string      :paper_type,    :null => false
# t.string      :paper_status,  :null => false
# t.datetime    :date
# t.integer     :minutes, :default => -1, :null => false
# t.integer     :room_id

class PaperTest < ActiveSupport::TestCase
  def setup
    @paper = papers(:paper1)
    @user = users(:user1)
  end

  def test_relations
    assert_equal( @user, @paper.speakers[0].user )
    assert( @paper.comments.include?(comments(:comment1)) )
    assert( @paper.resources.include?(resources(:resource1)) )
    assert( @paper.attendees.collect{ |a| a.user }.include?(@user) )
  end

  def test_create
    assert_difference "Paper.count", 1 do
      @paper = Paper.create(
        :title        => @paper.title,
        :description  => @paper.description,
        :family       => @paper.family,
        :status       => @paper.status,
        :minutes      => 0
      )
    end
  end

  def test_destroy_with_attendees_should_destroy_attendees
    assert_difference "Attendee.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  def test_destroy_with_resources_should_destroy_resources
    assert_difference "Resource.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  def test_destroy_with_votes_should_destroy_votes
    assert_difference "Vote.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  def test_destroy_with_speakers_should_destroy_speakers
    assert_difference "Speaker.count", -1 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  
  def test_destroy_with_comments_should_destroy_comments
    assert_difference "Comment.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end

  def test_validations
    paper = Paper.new()
    assert( !paper.valid? )
    assert( paper.errors.on(:title) )
    assert( paper.errors.on(:description) )
    assert( paper.errors.on(:family) )
    assert( paper.errors.on(:status) )
    
    paper = 
      Paper.new(
        :title        => @paper.title,
        :description  => @paper.description,
        :family       => @paper.family,
        :status       => @paper.status,
        :minutes      => @paper.minutes
      )
    assert( paper.valid? )
  end
end

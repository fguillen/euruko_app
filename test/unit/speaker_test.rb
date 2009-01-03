require File.dirname(__FILE__) + '/../test_helper'

class SpeakerTest < ActiveSupport::TestCase
  def setup
    @speaker = speakers(:speaker_user1_paper1)
    @user = users(:user1)
    @paper = papers(:paper1)
  end
  
  def test_relations
    assert_equal( @user, @speaker.user )
    assert_equal( @paper, @speaker.paper )
  end
  
  def test_create
    assert_difference "Speaker.count", 1 do
      Speaker.create(:user => @user, :paper => papers(:paper2))
    end
  end
  
  def test_destroy
    assert_difference "Speaker.count", -1 do
      @speaker.destroy
    end
  end

  
  def test_uniqueness
    assert_difference "Speaker.count", 0 do
      Speaker.create(
        :user     => @user,
        :paper    => @paper
      )
    end
  end
  
  def test_validations
    speaker = Speaker.new(:paper => @paper)
    assert( !speaker.valid? )
    assert( speaker.errors.on(:user_id) )
    assert( !speaker.errors.on(:paper_id) )
    
    speaker = Speaker.new(:user => @user)
    assert( !speaker.valid? )
    assert( !speaker.errors.on(:user_id) )
    assert( speaker.errors.on(:paper_id) )

    speaker = Speaker.new(:user => @user, :paper => @paper)
    assert( !speaker.valid? )
    
    speaker = Speaker.new(:user => @user, :paper => papers(:paper2))
    assert( speaker.valid? )
  end
end

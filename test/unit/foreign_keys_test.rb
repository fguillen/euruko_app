require File.dirname(__FILE__) + '/../test_helper'

class ForeignKeysTest < ActiveSupport::TestCase
  def test_attendee_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Attendee.create(:user => users(:user1), :paper_id => 23)
    end
    
    assert_raise(ActiveRecord::StatementInvalid) do
      Attendee.create(:user_id => 23, :paper => papers(:paper1))
    end
  end

  def test_comment_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Comment.create(:user => users(:user1), :paper_id => 23, :text => 'Just a Comment')
    end

    assert_raise(ActiveRecord::StatementInvalid) do
      Comment.create(:user_id => 23, :paper => papers(:paper1), :text => 'Just a Comment')
    end
  end
  
  def test_paper_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Paper.create(
        :title        => "Paper Title",
        :description  => "Paper description",
        :family       => Paper::FAMILY[:TUTORIAL],
        :minutes      => 0,
        :room_id      => -1
      )
    end
  end

  def test_carts_events_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      CartsEvent.create(
        :cart_id    => carts(:cart_user1_event1_purchased).id,
        :event_id   => -1
      )
    end
    
    assert_raise(ActiveRecord::StatementInvalid) do
      CartsEvent.create(
        :cart_id    => -1,
        :event_id   => events(:event1).id
      )
    end
  end
  
  def test_resource_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Resource.create(:user => users(:user1), :paper_id => -1, :url => 'http://mi.url')
    end

    assert_raise(ActiveRecord::StatementInvalid) do
      Resource.create(:user_id => -1, :paper => papers(:paper1), :url => 'http://mi.url')
    end
  end
  
  def test_speaker_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Speaker.create(:user => users(:user1), :paper_id => -1)
    end
    
    assert_raise(ActiveRecord::StatementInvalid) do
      Speaker.create(:user_id => -1, :paper => papers(:paper1))
    end
  end

  def test_vote_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Vote.create(:user => users(:user1), :paper_id => -1, :points => 2)
    end

    assert_raise(ActiveRecord::StatementInvalid) do
      Vote.create(:user_id => -1, :paper => papers(:paper1), :points => 2)
    end
  end
end
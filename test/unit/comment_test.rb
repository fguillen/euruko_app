require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = comments(:comment1)
    @user = users(:user1)
    @paper = papers(:paper1)
  end

  def test_relations
    assert_equal( @user, @comment.user )
    assert_equal( @paper, @comment.paper )
  end

  def test_create
    assert_difference "Comment.count", 1 do
      Comment.create(:user => @user, :paper => @paper, :text => 'Just a Comment')
    end
  end

  def test_destroy
    assert_difference "Comment.count", -1 do
      @comment.destroy
    end
  end

  def test_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Comment.create(:user => @user, :paper_id => 23, :text => 'Just a Comment')
    end

    assert_raise(ActiveRecord::StatementInvalid) do
      Comment.create(:user_id => 23, :paper => @paper, :text => 'Just a Comment')
    end
  end

  def test_validations
    comment = Comment.new()
    assert( !comment.valid? )
    assert( comment.errors.on(:user_id) )
    assert( comment.errors.on(:paper_id) )
    assert( comment.errors.on(:text) )

    comment = Comment.new(:user => @user, :paper => @paper, :text => 'Just a Comment')
    assert( comment.valid? )
  end

end

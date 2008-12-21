require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def test_should_create_comment
    assert_difference('Comment.count') do
      post(
        :create, 
        :comment => { 
          :paper_id => papers(:paper2).id,
          :user_id  => users(:user2).id,
          :text     => 'text'
        }
      )
    end

    assert_redirected_to comment_path(assigns(:comment))
  end
end

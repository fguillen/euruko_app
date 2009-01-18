require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def test_when_logged_should_create_comment
    login_as users(:user1)
    
    assert_difference('Comment.count') do
      post(
        :create, 
        :paper_id => papers(:paper2).id,
        :comment => { 
          :user_id  => users(:user2).id,
          :text     => 'text'
        }
      )
    end
    assert_redirected_to paper_path( papers(:paper2) )
  end
  
  def test_when_not_logged_on_create_should_redirect_to_new_session
    assert_difference('Comment.count', 0) do
      post(
        :create, 
        :paper_id => papers(:paper2).id,
        :comment => { 
          :user_id  => users(:user2).id,
          :text     => 'text'
        }
      )
    end
    assert_redirected_to new_session_path
  end
end

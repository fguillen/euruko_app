require File.dirname(__FILE__) + '/../test_helper'

class VotesControllerTest < ActionController::TestCase
  def test_should_create_vote
    assert_difference('Vote.count') do
      post(
        :create, 
        :vote => {
          :user_id    => users(:user1).id, 
          :paper_id   => papers(:paper2).id, 
          :points     => 2
        }
      )
    end

    assert_redirected_to vote_path(assigns(:vote))
  end

  def test_should_update_vote
    put :update, :id => votes(:vote1).id, :vote => { :points => 1 }
    assert_redirected_to vote_path(assigns(:vote))
  end

end

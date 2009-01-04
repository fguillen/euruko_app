require File.dirname(__FILE__) + '/../test_helper'

class VotesControllerTest < ActionController::TestCase
  def test_should_create_vote
    login_as users(:user1)

    assert_difference('Vote.count') do
      post(
        :create, 
        :paper_id => papers(:paper2).id, 
        :vote => {
          :points => 2
        }
      )
    end

    assert_redirected_to paper_path( papers(:paper2) )
  end

  def test_should_update_vote
    login_as users(:user1)
    
    put(
      :update,
      :paper_id => papers(:paper1).id, 
      :vote => { :points => 1 }
    )
    
    assert_redirected_to paper_path( papers(:paper1) )
  end

end

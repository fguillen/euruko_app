require File.dirname(__FILE__) + '/../test_helper'

class AttendeesControllerTest < ActionController::TestCase
  def setup
    @paper = papers(:paper2)
    @user = users(:user2)
  end
  
  def test_should_create_attendee
    login_as @user
    
    assert_difference('Attendee.count', 1) do
      post(
        :create, 
        :paper_id => @paper.id
      )
    end

    assert_redirected_to paper_path(@paper)
  end

  def test_should_destroy_attendee
    assert_difference('Attendee.count', -1) do
      delete(
        :destroy, 
        :paper_id => @paper.id,
        :id => attendees(:user1_go_paper1).id
      )
    end

    assert_redirected_to paper_path(@paper)
  end
end

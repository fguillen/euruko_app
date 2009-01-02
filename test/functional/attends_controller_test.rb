require File.dirname(__FILE__) + '/../test_helper'

class AttendsControllerTest < ActionController::TestCase
  def setup
    @paper = papers(:paper2)
    @user = users(:user2)
  end
  
  def test_should_create_attend
    assert_difference('Attend.count', 1) do
      post(
        :create, 
        :paper_id => @paper.id,
        :attend => {
          :user_id  => @user.id
        }
      )
    end

    assert_redirected_to paper_path(@paper)
  end

  def test_should_destroy_attend
    assert_difference('Attend.count', -1) do
      delete :destroy, :id => attends(:user1_go_paper1).id
    end

    assert_redirected_to attends_path
  end
end

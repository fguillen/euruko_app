require File.dirname(__FILE__) + '/../test_helper'

class SpeakersControllerTest < ActionController::TestCase
  def test_should_get_index
    # get :index
    # assert_response :success
    # assert_not_nil assigns(:speakers)
  end

  def test_should_create_speaker
    assert_difference('Speaker.count') do
      post( 
        :create,
        :paper_id    => papers(:paper2).id,
        :speaker => {
          :user_id     => users(:user1).id 
        }
      )
    end

    assert_redirected_to edit_paper_path( papers(:paper2) )
  end

  def test_should_destroy_speaker
    assert_difference('Speaker.count', -1) do
      delete(
        :destroy, 
        :paper_id => papers(:paper1),
        :id => speakers(:speaker_user1_paper1).id
      )
    end

    assert_redirected_to edit_paper_path( papers(:paper1) )
  end
end

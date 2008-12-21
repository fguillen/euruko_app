require File.dirname(__FILE__) + '/../test_helper'

class SpeakersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:speakers)
  end

  def test_should_create_speaker
    assert_difference('Speaker.count') do
      post( 
        :create, 
        :speaker => {
          :user_id     => users(:user1).id,
          :paper_id    => papers(:paper2).id
        }
      )
    end

    assert_redirected_to speaker_path(assigns(:speaker))
  end

  def test_should_destroy_speaker
    assert_difference('Speaker.count', -1) do
      delete :destroy, :id => speakers(:speaker_user1_paper1).id
    end

    assert_redirected_to speakers_path
  end
end

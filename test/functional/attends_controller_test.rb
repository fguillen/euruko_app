require File.dirname(__FILE__) + '/../test_helper'

class AttendsControllerTest < ActionController::TestCase
  def setup
    @paper = papers(:paper2)
    @user = users(:user2)
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:attends)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_attend
    assert_difference('Attend.count') do
      post(
        :create, 
        :attend => {
          :paper_id => @paper.id,
          :user_id  => @user.id
        }
      )
    end

    assert_redirected_to attend_path(assigns(:attend))
  end

  def test_should_show_attend
    get :show, :id => attends(:user1_go_paper1).id
    assert_response :success
  end

  def test_should_destroy_attend
    assert_difference('Attend.count', -1) do
      delete :destroy, :id => attends(:user1_go_paper1).id
    end

    assert_redirected_to attends_path
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class PapersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_paper
    login_as users(:user1)
    
    assert_difference('Paper.count') do
      post(
        :create, 
        :paper => { 
          :title        => "Paper Title",
          :description  => "Paper description",
          :family       => Paper::FAMILY[:TUTORIAL],
          :status       => Paper::STATUS[:PROPOSED],
          :minutes      => 0
        }
      )
    end

    assert_redirected_to paper_path(assigns(:paper))
  end

  def test_without_login_should_show_paper
    get :show, :id => papers(:paper1).id
    assert_response :success
  end

  def test_with_login_should_show_paper
    login_as users(:user1)
    get :show, :id => papers(:paper1).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => papers(:paper1).id
    assert_response :success
  end

  def test_should_update_paper
    put :update, :id => papers(:paper1).id, :paper => { :title => 'another title' }
    assert_redirected_to edit_paper_path(assigns(:paper))
  end

  def test_should_destroy_paper
    assert_difference('Paper.count', -1) do
      delete :destroy, :id => papers(:paper1).id
    end

    assert_redirected_to papers_path
  end
end

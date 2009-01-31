require File.dirname(__FILE__) + '/../test_helper'

class ResourcesControllerTest < ActionController::TestCase

  def test_on_create_with_speaker_logged_should_create_resource
    login_as users(:user1)
    
    assert_difference('Resource.count') do
      post(
        :create, 
        :paper_id   => papers(:paper1).id,
        :resource => {
          :user_id    => users(:user1).id,
          :url        => 'http://mi.url',
          :name       => 'resource name'
        }
      )
    end

    assert_equal( 'resource name', Resource.last.name )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(papers(:paper1))
  end

  def test_on_create_with_logged_but_not_speaker_not_admin_should_response_404
    login_as users(:user2)
    
    assert_difference('Resource.count', 0) do
      post(
        :create, 
        :paper_id   => papers(:paper1).id,
        :resource => {
          :user_id    => users(:user1).id,
          :url        => 'http://mi.url'
        }
      )
    end

    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_on_create_with_logged_but_not_speaker_but_admin_should_create_resource
    login_as users(:user_admin)
    
    assert_difference('Resource.count', 1) do
      post(
        :create, 
        :paper_id   => papers(:paper1).id,
        :resource => {
          :user_id    => users(:user1).id,
          :url        => 'http://mi.url'
        }
      )
    end

    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(papers(:paper1))
  end
  
  def test_on_create_with_not_logged_should_redirecto_to_new_session
    assert_difference('Resource.count', 0) do
      post(
        :create, 
        :paper_id   => papers(:paper1).id,
        :resource => {
          :user_id    => users(:user1).id,
          :url        => 'http://mi.url'
        }
      )
    end

    assert_nil( flash[:notice] )
    assert_redirected_to new_session_path
  end
  
  
  def test_on_destroy_and_logged_speaker_should_destroy_resource
    login_as users(:user1)
    
    assert_difference('Resource.count', -1) do
      delete(
        :destroy,
        :paper_id => papers(:paper1).id,
        :id       => resources(:resource1).id
      )
    end
    
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(papers(:paper1))
  end
  
  def test_on_destroy_and_logged_but_not_speaker_not_admon_should_response_404
    login_as users(:user2)
    
    assert_difference('Resource.count', 0) do
      delete(
        :destroy,
        :paper_id => papers(:paper1).id,
        :id       => resources(:resource1).id
      )
    end
    
    assert_nil( flash[:notice] )
    assert_response 404
  end
  
  def test_on_destroy_and_logged_but_not_speaker_but_admin_should_destroy_resource
    login_as users(:user_admin)
    
    assert_difference('Resource.count', -1) do
      delete(
        :destroy,
        :paper_id => papers(:paper1).id,
        :id       => resources(:resource1).id
      )
    end
    
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(papers(:paper1))
  end
  
  def test_on_destroy_and_not_logged_should_redirect_to_new_session
    assert_difference('Resource.count', 0) do
      delete(
        :destroy,
        :paper_id => papers(:paper1).id,
        :id       => resources(:resource1).id
      )
    end
    
    assert_nil( flash[:notice] )
    assert_redirected_to new_session_path
  end
end

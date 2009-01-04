require File.dirname(__FILE__) + '/../test_helper'

class ResourcesControllerTest < ActionController::TestCase

  def test_should_create_resource
    login_as users(:user1)
    
    assert_difference('Resource.count') do
      post(
        :create, 
        :paper_id   => papers(:paper1).id,
        :resource => {
          :user_id    => users(:user1).id,
          :url        => 'http://mi.url'
        }
      )
    end

    assert_redirected_to edit_paper_path(papers(:paper1))
  end

  def test_should_destroy_resource
    assert_difference('Resource.count', -1) do
      delete(
        :destroy,
        :paper_id => papers(:paper1).id,
        :id       => resources(:resource1).id
      )
    end

    assert_redirected_to edit_paper_path(papers(:paper1))
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class ResourcesControllerTest < ActionController::TestCase

  def test_should_create_resource
    assert_difference('Resource.count') do
      post(
        :create, 
        :resource => {
          :user_id    => users(:user1).id, 
          :paper_id   => papers(:paper1).id, 
          :url        => 'http://mi.url'
        }
      )
    end

    assert_redirected_to resource_path(assigns(:resource))
  end

  def test_should_destroy_resource
    assert_difference('Resource.count', -1) do
      delete :destroy, :id => resources(:resource1).id
    end

    assert_redirected_to resources_path
  end
end

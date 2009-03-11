require File.dirname(__FILE__) + '/../test_helper'

class AvailablePlacesCounterControllerTest < ActionController::TestCase
  def test_show
    get(
      :show,
      :id => events(:event1)
    )
    
    assert_response :success
    assert_equal( '8', @response.body )
  end
end
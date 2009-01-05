require File.dirname(__FILE__) + '/../test_helper'

class ShopingCartsControllerTest < ActionController::TestCase
  
  def test_new
    login_as users(:user1)
    get :new
    assert_not_nil( assigns(:events) )
  end
  
end
require File.dirname(__FILE__) + '/../test_helper'

class InvoicesControllerTest < ActionController::TestCase
  def setup
  end
  
  # fguillen 2009-06-23: 
  # invoice creation closed
  #
  # def test_on_create
  #   @user = users(:user1)
  #   login_as @user
  #   
  #   cart = Factory(:cart, :user => @user, :status => Cart::STATUS[:COMPLETED] )
  #   cart.update_attribute( :invoice_info, "My Compaty\nMy street" )
  #   
  #   4.times do 
  #     cart.events << Factory(:event)
  #   end
  #   
  #   assert_difference('Invoice.count', 1) do
  #     post(
  #       :create, 
  #       :id => cart.id
  #     )
  #   end
  #   
  #   assert_redirected_to cart_path( cart )
  # end
  # 
  # def test_on_create_with_not_logged_user_should_response_302
  #   @user = users(:user1)    
  #   cart = Factory(:cart, :user => @user, :status => Cart::STATUS[:COMPLETED] )
  #   
  #   assert_difference('Invoice.count', 0) do
  #     post(
  #       :create, 
  #       :id => cart.id
  #     )
  #   end
  #   assert_redirected_to new_session_path
  # end
  # 
  # def test_on_create_with_not_admin_not_owner_cart_should_response_404
  #   @user = users(:user1)
  #   login_as users(:user2)
  #   
  #   cart = Factory(:cart, :user => @user, :status => Cart::STATUS[:COMPLETED] )
  #   
  #   assert_difference('Invoice.count', 0) do
  #     post(
  #       :create, 
  #       :id => cart.id
  #     )
  #   end
  #   
  #   assert_response 404
  # end
  # 
  # def test_on_create_with_admin_not_owner_cart_should_create_invoice
  #   @user = users(:user1)
  #   login_as users(:user_admin)
  #   
  #   cart = Factory(:cart, :user => @user, :status => Cart::STATUS[:COMPLETED] )
  #   
  #   assert_difference('Invoice.count', 1) do
  #     post(
  #       :create, 
  #       :id => cart.id
  #     )
  #   end
  # 
  #   assert_redirected_to cart_path( cart )
  # end
end
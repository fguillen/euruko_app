# require File.dirname(__FILE__) + '/../test_helper'
# 
# class PaymentsControllerTest < ActionController::TestCase
# 
#   def test_on_create_with_logged_should_create_payment
#     login_as users(:user1)
#     
#     assert_difference('Payment.count') do
#       post(
#         :create, 
#         :payment => {
#           :user_id     => users(:user1).id,
#           :event_id    => events(:event2).id
#         }
#       )
#     end
# 
#     assert_redirected_to payment_path(assigns(:payment))
#   end
#   
#   def test_on_create_with_not_logged_should_redirect_to_new_session
#     assert_difference('Payment.count', 0) do
#       post(
#         :create, 
#         :payment => {
#           :user_id     => users(:user1).id,
#           :event_id    => events(:event2).id
#         }
#       )
#     end
# 
#     assert_redirected_to new_session_path
#   end
# 
# end

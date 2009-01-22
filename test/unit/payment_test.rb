# # t.integer     :user_id,     :null => false
# # t.integer     :event_id,    :null => false
# 
# require File.dirname(__FILE__) + '/../test_helper'
# 
# class PaymentTest < ActiveSupport::TestCase
#   def setup
#     @payment = payments(:payment_user1_event1)
#     @event = events(:event1)
#     @user = users(:user1)
#   end
# 
#   def test_relations
#     assert_equal( @user, @payment.user )
#     assert_equal( @event, @payment.event )
#   end
# 
#   def test_create
#     assert_difference "Payment.count", 1 do
#       Payment.create(
#         :user     => @user,
#         :event    => events(:event2)
#       )
#     end
#   end
#   
#   def test_uniqueness
#     assert_difference "Payment.count", 0 do
#       Payment.create(
#         :user     => @user,
#         :event    => @event
#       )
#     end
#   end
# 
#   def test_validations
#     payment = Payment.new()
#     assert( !payment.valid? )
#     assert( payment.errors.on(:user_id) )
#     assert( payment.errors.on(:event_id) )
#     
#     payment = 
#       Payment.new(
#         :user   => @user,
#         :event  => events(:event2)
#       )
#     assert( payment.valid? )
#   end
# end

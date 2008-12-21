require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase

  def test_should_create_payment
    assert_difference('Payment.count') do
      post(
        :create, 
        :payment => {
          :user_id     => users(:user1).id,
          :event_id    => events(:event2).id
        }
      )
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

end

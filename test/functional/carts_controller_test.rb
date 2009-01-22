require File.dirname(__FILE__) + '/../test_helper'

class CartsControllerTest < ActionController::TestCase
  
  def test_show
    login_as users(:user1)
    get :show
    assert_not_nil( assigns(:cart) )
  end
  
  def test_complete
    login_as users(:user2)
    
    # assert_difference "Payment.count", 2 do
      
      get(
        :complete,
        "protection_eligibility"=>"Eligible", "tax"=>"0.00", "payment_status"=>"Completed", "address_name"=>"Test User", "business"=>"seller_1231200230_biz@gmail.com", "address_country"=>"United States", "address_city"=>"San Jose", "payer_email"=>"buyer_1231201025_per@gmail.com", "receiver_id"=>"PDELP3ZPC4CFL", "residence_country"=>"US", "payment_gross"=>"30243.00", "merchant_return_link"=>"Volver a Fernando Guillen's Test Store", "mc_shipping"=>"0.00", "receiver_email"=>"seller_1231200230_biz@gmail.com", "invoice"=> carts(:cart_user1_event1_purchased), "mc_gross_1"=>"18126.00", "address_street"=>"1 Main St", "mc_handling1"=>"0.00", "verify_sign"=>"AfHifvSigeqzzSlb4WmWwnRdnG9bAwxVKx0P52THhLhk8Gz24YJ9jB42", "mc_gross_2"=>"12117.00", "address_zip"=>"95131", "mc_handling2"=>"0.00", "memo"=>"una nota desde paypal", "item_name1"=>"Necessitatibus quisquam explicabo eius.", "txn_type"=>"cart", "mc_currency"=>"USD", "transaction_subject"=>"Shopping Cart", "charset"=>"windows-1252", "address_country_code"=>"US", "txn_id"=>"02M22715HK8370023", "item_name2"=>"Rerum quos quo est in.", "item_number1"=>events(:event1).id, "notify_version"=>"2.6", "payer_status"=>"verified", "tax1"=>"0.00", "address_state"=>"CA", "payment_fee"=>"877.35", "quantity1"=>"1", "address_status"=>"confirmed", "item_number2"=>events(:event2).id, "payment_date"=>"15:51:17 Jan 11, 2009 PST", "mc_handling"=>"0.00", "mc_fee"=>"877.35", "tax2"=>"0.00", "quantity2"=>"1", "first_name"=>"Test", "num_cart_items"=>"2", "mc_shipping1"=>"0.00", "payment_type"=>"instant", "test_ipn"=>"1", "mc_gross"=>"30243.00", "payer_id"=>"8K4R8XDDXMJY4", "mc_shipping2"=>"0.00", "last_name"=>"User", "custom"=>""
      )
    # end
    
    assert_not_nil( flash[:notice] )
    # assert( events(:event1).is_paid_for_user?( users(:user2) ) )
    # assert( events(:event2).is_paid_for_user?( users(:user2) ) )
    assert_response :success
  end
  
  def test_on_complete_with_not_valid_cart_id_should_respond_404
    login_as users(:user1)
    
    get(
      :complete,
      :invoice => -1
    )
    
    assert_response 404
  end
  
  def test_on_notificate_with_not_valid_cart_id_should_respond_404
    login_as users(:user1)
    
    get(
      :notificate,
      :invoice => -1
    )
    
    assert_response 404
  end
end
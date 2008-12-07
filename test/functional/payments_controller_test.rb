require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post :create, :payment => { }
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should show payment" do
    get :show, :id => payments(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => payments(:one).id
    assert_response :success
  end

  test "should update payment" do
    put :update, :id => payments(:one).id, :payment => { }
    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, :id => payments(:one).id
    end

    assert_redirected_to payments_path
  end
end

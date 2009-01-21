class CartsController < ApplicationController
  before_filter :login_required

  # # POST /payments
  # # POST /payments.xml
  # def create
  #   @payment = Payment.new(params[:payment])
  # 
  #   respond_to do |format|
  #     if @payment.save
  #       flash[:notice] = 'Payment was successfully created.'
  #       format.html { redirect_to(@payment) }
  #       format.xml  { render :xml => @payment, :status => :created, :location => @payment }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  
  def show
    logger.info ( "XXX: on show" )
    
    @cart = current_cart
    
    logger.info( "XXX: cart: #{@cart}" )
    
  end
  
  def confirm
    logger.info ( "XXX: on confirm" )
        
    current_cart.events = Event.find( params[:event_ids] )
    current_cart.invoice_info = params[:invoice_info]
    
    current_cart.save!
    
    @cart = current_cart
    logger.info ( "XXX: out confirm" )
    
  end
  
  # Parameters: {"protection_eligibility"=>"Eligible", "tax"=>"0.00", "payment_status"=>"Completed", "address_name"=>"Test User", "business"=>"seller_1231200230_biz@gmail.com", "address_country"=>"United States", "address_city"=>"San Jose", "payer_email"=>"buyer_1231201025_per@gmail.com", "receiver_id"=>"PDELP3ZPC4CFL", "residence_country"=>"US", "payment_gross"=>"30243.00", "merchant_return_link"=>"Volver a Fernando Guillen's Test Store", "mc_shipping"=>"0.00", "receiver_email"=>"seller_1231200230_biz@gmail.com", "invoice"=>"1231717821", "mc_gross_1"=>"18126.00", "address_street"=>"1 Main St", "mc_handling1"=>"0.00", "verify_sign"=>"AfHifvSigeqzzSlb4WmWwnRdnG9bAwxVKx0P52THhLhk8Gz24YJ9jB42", "mc_gross_2"=>"12117.00", "address_zip"=>"95131", "mc_handling2"=>"0.00", "memo"=>"una nota desde paypal", "item_name1"=>"Necessitatibus quisquam explicabo eius.", "txn_type"=>"cart", "mc_currency"=>"USD", "transaction_subject"=>"Shopping Cart", "charset"=>"windows-1252", "address_country_code"=>"US", "txn_id"=>"02M22715HK8370023", "item_name2"=>"Rerum quos quo est in.", "item_number1"=>"11", "notify_version"=>"2.6", "payer_status"=>"verified", "tax1"=>"0.00", "address_state"=>"CA", "payment_fee"=>"877.35", "quantity1"=>"1", "address_status"=>"confirmed", "item_number2"=>"12", "payment_date"=>"15:51:17 Jan 11, 2009 PST", "mc_handling"=>"0.00", "mc_fee"=>"877.35", "tax2"=>"0.00", "quantity2"=>"1", "first_name"=>"Test", "num_cart_items"=>"2", "mc_shipping1"=>"0.00", "payment_type"=>"instant", "test_ipn"=>"1", "mc_gross"=>"30243.00", "payer_id"=>"8K4R8XDDXMJY4", "mc_shipping2"=>"0.00", "last_name"=>"User", "custom"=>""}
  def complete
    logger.debug( "params: #{params.inspect}" )
    
    @cart = Cart.find_by_id( params[:invoice] )
    record_not_found  if @cart.nil?
    
    if @cart.status == "Completed"
      flash[:notice] = 'Payment was successfully.'
    else
      flash[:error] = 'Some error on payment!'
    end
    
    redirect_to :action => :show
  end
  
end

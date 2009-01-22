class CartsController < ApplicationController
  before_filter :login_required, :except => [:notificate]
  protect_from_forgery :except => [:notificate]
  
  def show
    @cart = current_cart
  end
  
  def confirm
    current_cart.events = Event.find( params[:event_ids] )
    current_cart.invoice_info = params[:invoice_info]
    
    current_cart.save!
    
    @cart = current_cart
  end
  
  def notificate
    logger.debug( "XXX: on notificate" )
    logger.debug( "params: #{params.inspect}" )
  
    @cart = Cart.find_by_id( params[:invoice] )
    record_not_found and return  if @cart.nil?
    
    @cart.paypal_params   = params
    @cart.status          = params[:payment_status]
    @cart.transaction_id  = params[:txn_id]
    @cart.purchased_at    = Time.now  if @cart.status == "Completed"
    
    @cart.save!
  
    render :nothing => true
  end

  
  def complete
    logger.debug( "params: #{params.inspect}" )
    
    @cart = Cart.find_by_id( params[:invoice] )
    record_not_found and return  if @cart.nil?
    
    if @cart.status == "Completed"
      flash[:notice] = 'Payment was successfully.'
    else
      flash[:error] = 'Some error on payment!'
    end
  end
  
end

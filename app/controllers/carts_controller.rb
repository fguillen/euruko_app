class CartsController < ApplicationController
  before_filter :login_required, :except => [:notificate]
  
  protect_from_forgery :except => [:notificate]
  
  
  # this is called for the user or admin
  # if not param[:id] sended return the current_cart
  # if params[:id] sended return the Cart but only if admin?
  def show
    @cart = current_cart           if params[:id].nil?
    @cart = Cart.find(params[:id])  if !params[:id].nil? && admin?
    record_not_found and return    if @cart.nil?
  end
  
  # this is colled for the user
  # update the current_cart
  # only add the Event pass through params[:event_ids]
  def confirm
    current_cart.carts_events.destroy_all
    
    if( params[:event_ids].nil? )
      flash[:error] = 'You should select at less one Event'
      redirect_to :action => 'show'
      return
    end
    
    current_cart.events = Event.find( params[:event_ids] )
    current_cart.invoice_info = params[:invoice_info]
    
    current_cart.save!
    
    @cart = current_cart
  end
  
  # this is the IPN paypal action call
  def notificate
    logger.info( "XXX: on notificate" )
    logger.info( "params: #{params.inspect}" )
  
    @cart = Cart.find( params[:invoice] )
    record_not_found and return  if @cart.nil?
    
    @cart.paypal_params   = params
    @cart.status          = params[:payment_status]
    @cart.transaction_id  = params[:txn_id]
    @cart.purchased_at    = Time.now  if @cart.status == "Completed"
    
    @cart.save!
  
    render :nothing => true
  end

  
  # this is the return_url from Paypal
  def complete
    logger.info( "params: #{params.inspect}" )
    
    @cart = current_user.carts.find( params[:invoice] )
    record_not_found and return  if @cart.nil?
    
    if @cart.status == "Completed"
      flash[:notice] = 'Payment was successfully.'
    else
      flash[:error] = 'Some error on payment!'
    end
  end
  
end

class CartsController < ApplicationController
  protect_from_forgery :except => [:create]
  

  # update the Cart with the payment notification
  def create
    logger.debug( "params: #{params.inspect}" )
  
    @cart = Cart.find_by_id( params[:invoice] )
    record_not_found  if @cart.nil?
    
    @cart.params          = params
    @cart.status          = params[:payment_status]
    @cart.transaction_id  = params[:txn_id]
    @cart.purchased_at    = Time.now  if @cart.status == "Completed"
  
    render :nothing => true
  end
end
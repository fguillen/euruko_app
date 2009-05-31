class InvoicesController < ApplicationController
  before_filter :login_required 
  
  def create
    puts "XXX: create"
    @cart = Cart.find( params[:id] )                if admin?
    @cart = current_user.carts.find( params[:id] )  if !admin?
    
    record_not_found and return  unless @cart.is_purchased?
    record_not_found and return  unless @cart.invoice.nil?
    
    Invoice.print( @cart )
    flash[:notice] = 'Invoice created successfully, please use the link bellow to download it.'
    
    redirect_to :controller => 'carts', :action => 'show', :id => @cart
  end
end
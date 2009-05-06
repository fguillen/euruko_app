class InvoicesController < ApplicationController
  def create
    @cart = Cart.find( params[:id] )
    redirect_to :controller => 'carts', :action => 'show', :id => @cart
  end
end
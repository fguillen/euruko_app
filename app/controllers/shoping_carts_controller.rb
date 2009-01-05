class ShopingCartsController < ApplicationController
  def new
    @events = Event.find(:all)
  end
end
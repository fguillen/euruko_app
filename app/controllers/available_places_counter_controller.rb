class AvailablePlacesCounterController < ApplicationController
  def show
    render :text => Event.find( params[:id] ).remaining_capacity
  end
end
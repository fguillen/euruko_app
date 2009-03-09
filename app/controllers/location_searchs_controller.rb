class LocationSearchsController < ApplicationController
  def create
    @places = YahooGeoplanetSearchWrapper.search( params[:query], APP_CONFIG[:yahoo_id] )
    render :partial => 'location_searchs/places'
  end
end
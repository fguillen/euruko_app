class StaticPagesController < ApplicationController
  def show
    if( params[:id].blank? )
      record_not_found
    else
      render :action => params[:id]
    end    
  end
end
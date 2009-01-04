class CalendarsController < ApplicationController
  def show
    @papers = Paper.find_all_by_status( Paper::STATUS[:CONFIRMED] )
  end
end
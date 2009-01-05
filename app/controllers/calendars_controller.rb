class CalendarsController < ApplicationController
  def show
    @rooms, @papers, @dates = Calendar.charge_calendar_elements
  end
end
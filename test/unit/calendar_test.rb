require File.dirname(__FILE__) + '/../test_helper'


class CalendarTest < ActiveSupport::TestCase
  def test_charge_calendar_elements
    @rooms, @papers, @dates = Calendar.charge_calendar_elements
    
    # puts "ROOMS"
    # @rooms.each do |e|
    #   puts e.inspect
    # end
    # 
    # puts "PAPERs"
    # @papers.each do |e|
    #   puts e.inspect
    # end
    # 
    # puts "dates"
    # @dates.each do |e|
    #   puts e.inspect
    # end
  end
end
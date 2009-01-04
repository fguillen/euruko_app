class Calendar
  def charge_calendar
    @days = 
    @papers = Paper.find_all_by_status( Paper::STATUS[:CONFIRMED] )
  end
end
class Calendar
  def self.charge_calendar_elements
    @rooms = Room.find(:all)
    @papers = Paper.visible( :order => 'date asc' )
    @dates = @papers.collect { |p| p.date_just_date }.uniq
    
    return @rooms, @papers, @dates
  end
end
class Calendar
  def self.charge_calendar_elements
    @rooms = Room.find(:all)
    @papers = Paper.find(:all, :order => 'date', :conditions => [ "status = ? or status = ?", Paper::STATUS[:ACEPTED], Paper::STATUS[:CONFIRMED] ] )
    @dates = @papers.collect { |p| p.date_just_date }.uniq
    
    return @rooms, @papers, @dates
  end
end
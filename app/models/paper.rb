class Paper < ActiveRecord::Base
  has_many :speakers,       :dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :votes,          :dependent => :destroy
  has_many :resources,      :dependent => :destroy
  has_many :attendees,      :dependent => :destroy
  # 
  # has_many :attendees,      :through => :attendees, :source => :user
  # has_many :user_speakers,  :through => :speakers, :source => :user
  
  belongs_to :room
  
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :family
  validates_presence_of :status
  validates_numericality_of :minutes
  
  # TODO: hacer que esto funcione
  # validates_inclusion_of :status, :in => Paper::STATUS.values
  # validates_inclusion_of :family, :in => FAMILIES.values
  
  before_save :update_date
  
  STATUS = {
    :PROPOSED       => 'Proposed',
    :UNDER_REVIEW   => 'Under Review',
    :ACEPTED        => 'Acepted',
    :DECLINED       => 'Declined',
    :CONFIRMED      => 'Confirmed'  
  }
  
  FAMILY = {
    :TUTORIAL => 'Tutorial',
    :SESSION  => 'Session',
    :KEYNOTE  => 'Keynote',
    :EVENT    => 'Event' 
  }
  
  
  def add_speaker(user)
    self.speakers.build( :user => user )
  end

  ## date form system : INI ##
  def date_form
    return nil  if self.date.nil?
    return self.date.strftime( "%Y/%m/%d" )
  end
  
  def time_form
    return nil  if self.date.nil?
    return self.date.strftime( "%H:%M" )
  end
  
  def date_form=( value )
    @date_form = value
  end

  def time_form=( value )
    @time_form = value
  end

  def update_date
    if( !@date_form.blank? && !@time_form.blank? )
      self.date = Time.parse( "#{@date_form} #{@time_form}" )
    end
  end
  ## date form system : END ##

  
end

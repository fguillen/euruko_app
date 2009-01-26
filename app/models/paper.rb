class Paper < ActiveRecord::Base
  
  permalink :title
  
  has_many :speakers,       :dependent => :destroy
  has_many :speaking_users,  :through => :speakers, :source => :user
  has_many :comments,       :dependent => :destroy
  has_many :votes,          :dependent => :destroy
  has_many :resources,      :dependent => :destroy
  has_many :attendees,      :dependent => :destroy

    
  # 
  # has_many :attendees,      :through => :attendees, :source => :user

  
  belongs_to :room
  belongs_to :creator, :class_name => 'User'
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :description
  validates_presence_of :family
  validates_numericality_of :minutes
  validates_associated :creator
  validates_presence_of :creator
  
  # TODO: hacer que esto funcione
  # validates_inclusion_of :status, :in => Paper::STATUS.values
  # validates_inclusion_of :family, :in => FAMILIES.values
  
  simple_text_fields
  
  before_save :update_date
  before_create :update_status
  after_create :notify_by_mail
  
  attr_protected :status
  attr_protected :creator_id
  
  
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
  
  named_scope :visible, :conditions => { :status => [Paper::STATUS[:ACEPTED], Paper::STATUS[:CONFIRMED] ]  }
  
  def add_speaker(user)
    if user.public_profile?
      self.speakers.build( :user => user )
    else
      raise Exception.new("Users with private profile can't be added as speakers")
    end
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

  # Return only the date and not the time
  def date_just_date
    Time.mktime( self.date.year, self.date.month, self.date.day )
  end
  
  # Return true if the paper date_just_date is equal to date and the room is the room
  def on_date_and_room_id?( date, room_id )
    return self.room.id == room_id && self.date_just_date.to_i == date.to_i
  end
  
  def visible?
    return [Paper::STATUS[:ACEPTED], Paper::STATUS[:CONFIRMED]].include?( self.status )
  end
  
  def can_see_it?( user )
    return( self.visible? || (!user.nil? && user.is_speaker_on?(self)) || (!user.nil? && user.admin?) )
  end
  
  def can_change_status_to?( user, status )
    return ( user.admin? || ((self.status == Paper::STATUS[:ACEPTED]) && status == Paper::STATUS[:CONFIRMED]) )
  end

  def notify_by_mail
    APP_CONFIG['email_paper_recipients'].split(',').each{ |mail| SystemMailer.deliver_paper(mail, self) }
  end

  def user_candidates
    User.find_public - self.speaking_users
  end
  
  private
  
    def update_status
      self.status ||= Paper::STATUS[:PROPOSED]
    end
end

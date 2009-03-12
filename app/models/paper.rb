class Paper < ActiveRecord::Base
  
  permalink :title
  
  has_many :speakers,       :dependent => :destroy
  has_many :speaking_users,  :through => :speakers, :source => :user
  has_many :comments,       :dependent => :destroy
  has_many :votes,          :dependent => :destroy
  has_many :resources,      :dependent => :destroy
  has_many :attendees,      :dependent => :destroy
  
  # paperclip
  has_attached_file :photo, 
                    :styles => { :medium => "150x150#", :small => "75x75#" },
                    :url  => "/paper_files/:id/photos/:style/:basename.:extension",
                    :path => ":rails_root/public/paper_files/:id/photos/:style/:basename.:extension"


  validates_attachment_size :photo, :less_than => 1.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_attachment_width :photo, :greater_than => 150, :less_than => 1000
  validates_attachment_height :photo, :greater_than => 150, :less_than => 1000
    
  # 
  # has_many :attendees,      :through => :attendees, :source => :user

  
  belongs_to :room
  belongs_to :creator, :class_name => 'User'
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :description
  validates_presence_of :family
  validates_presence_of :status
  validates_numericality_of :minutes
  validates_associated :creator
  validates_presence_of :creator
  
  # TODO: hacer que esto funcione
  # validates_inclusion_of :status, :in => Paper::STATUS.values
  # validates_inclusion_of :family, :in => FAMILIES.values
  
  simple_text_fields
  
  before_validation_on_create :initialize_status
  before_validation_on_create :initialize_family
  before_save :update_date
  after_create :notify_by_mail
  
  attr_protected(
    :status,
    :creator_id,
    :minutes,
    :family,
    :room_id,
    :date,
    :date_form,
    :time_form
  )
  
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
    :BREAK    => 'Break'
  }
  
  named_scope :visible, :conditions => { :status => [Paper::STATUS[:ACEPTED], Paper::STATUS[:CONFIRMED] ]  }
  named_scope :not_break, :conditions => [ "family != ?", Paper::FAMILY[:BREAK] ]
  named_scope :break, :conditions => { :family => Paper::FAMILY[:BREAK] }
  named_scope :date_ordered, :order => 'date asc'
  
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
    SystemMailer.deliver_paper( self )
  end

  def user_candidates
    User.activated.public_profile.ordered - self.speaking_users
  end
  
  def rate
    return nil  if self.votes.count == 0
    return self.votes.average(:points).round.to_i
  end
  
  def fill_admin(params)
    self.minutes    = params[:minutes]    if params[:minutes]
    self.family     = params[:family]     if params[:family]
    self.room_id    = params[:room_id]    if params[:room_id]
    self.status     = params[:status]     if params[:status]
    self.date_form  = params[:date_form]  if params[:date_form]
    self.time_form  = params[:time_form]  if params[:time_form]
  end
  
  private
  
    def initialize_status
      self.status ||= Paper::STATUS[:PROPOSED]
    end
    
    def initialize_family
      self.family ||= Paper::FAMILY[:SESSION]
    end
end

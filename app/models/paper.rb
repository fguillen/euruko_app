class Paper < ActiveRecord::Base
  has_many :speakers
  has_many :user_speakers, :through => :speakers, :source => :user
  has_many :comments
  has_many :resources
  has_many :attends
  has_many :attendents, :through => :attends, :source => :user
  
  belongs_to :room
  
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :type
  validates_presence_of :status
  validates_numericality_of :minutes
  
  STATUS_PROPOSED       = "Proposed"
  STATUS_UNDER_REVIEW   = "Under Review"
  STATUS_ACEPTED        = "Acepted"
  STATUS_DECLINED       = "Declined"
  STATUS_CONFIRMED      = "Confirmed"
  
  TYPE_TUTORIAL         = "Tutorial"
  TYPE_SESSION          = "Session"
  TYPE_KEYNOTE          = "Keynote"
  TYPE_EVENT            = "Event"
  
end

class Paper < ActiveRecord::Base
  has_many :speakers,       :dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :votes,          :dependent => :destroy
  has_many :resources,      :dependent => :destroy
  has_many :attends,        :dependent => :destroy

  has_many :attendents,     :through => :attends, :source => :user
  has_many :user_speakers,  :through => :speakers, :source => :user
  
  belongs_to :room
  
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :family
  validates_presence_of :status
  validates_numericality_of :minutes
  
  # validates_inclusion_of :source_type, :in => SOURCE_TYPES.keys.map(&:to_s)
  
  STATUS_PROPOSED       = "Proposed"
  STATUS_UNDER_REVIEW   = "Under Review"
  STATUS_ACEPTED        = "Acepted"
  STATUS_DECLINED       = "Declined"
  STATUS_CONFIRMED      = "Confirmed"
  
  FAMILY_TUTORIAL         = "Tutorial"
  FAMILY_SESSION          = "Session"
  FAMILY_KEYNOTE          = "Keynote"
  FAMILY_EVENT            = "Event"
  
end

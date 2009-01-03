class Paper < ActiveRecord::Base
  has_many :speakers,       :dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :votes,          :dependent => :destroy
  has_many :resources,      :dependent => :destroy
  has_many :attendees,      :dependent => :destroy

  has_many :attendees,      :through => :attendees, :source => :user
  has_many :user_speakers,  :through => :speakers, :source => :user
  
  belongs_to :room
  
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :family
  validates_presence_of :status
  validates_numericality_of :minutes
  
  # TODO: hacer que esto funcione
  # validates_inclusion_of :status, :in => Paper::STATUS.values
  # validates_inclusion_of :family, :in => FAMILIES.values
  
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
  
end

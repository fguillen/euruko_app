class Paper < ActiveRecord::Base
  has_many :speakers
  has_many :user_speakers, :through => :speakers, :source => :user
  has_many :comments
  has_many :resources
  
  belongs_to :paper_type
  belongs_to :paper_status
  belongs_to :room
  
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :paper_type_id
  validates_presence_of :paper_status_id
  validates_numericality_of :minutes
  
  
  
end

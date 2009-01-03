class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :paper
  
  validates_presence_of :user_id
  validates_presence_of :paper_id
  validates_uniqueness_of :paper_id, :scope => :user_id, :message => 'This User is already attendee to this Paper'
end

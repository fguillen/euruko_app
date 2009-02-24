class Vote < ActiveRecord::Base
  belongs_to :paper
  belongs_to :user
  
  validates_presence_of :paper_id
  validates_presence_of :user_id
  validates_numericality_of :points
  validates_uniqueness_of :paper_id, :scope => :user_id, :message => 'This User already has voted on this Paper'
  validates_inclusion_of :points, :in => 1..5
end

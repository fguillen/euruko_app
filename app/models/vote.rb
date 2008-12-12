class Vote < ActiveRecord::Base
  belongs_to :paper
  belongs_to :user
  
  validates_numericality_of :points
end

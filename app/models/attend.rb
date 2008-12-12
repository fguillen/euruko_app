class Attend < ActiveRecord::Base
  belongs_to :user
  belongs_to :paper
  
  validates_presence_of :user_id
  validates_presence_of :paper_id
end

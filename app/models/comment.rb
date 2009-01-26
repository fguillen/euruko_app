class Comment < ActiveRecord::Base
  belongs_to :paper
  belongs_to :user
  
  validates_presence_of :paper_id
  validates_presence_of :user_id
  validates_presence_of :text

  simple_text_fields
end

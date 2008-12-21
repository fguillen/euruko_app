class Resource < ActiveRecord::Base
  belongs_to :paper
  belongs_to :user
  
  validates_presence_of :url
  validates_presence_of :user_id
  validates_presence_of :paper_id
  validates_uniqueness_of :url, :scope => :paper_id, :message => 'This Paper has already this resource associated'
end

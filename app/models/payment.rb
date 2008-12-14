class Payment < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  validates_presence_of :event_id
  validates_presence_of :user_id
end

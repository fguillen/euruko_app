class Event < ActiveRecord::Base
  has_many :payments
  
  validates_numericality_of :price_cents
end

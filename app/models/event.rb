class NotDeletableEventException < Exception
end

class Event < ActiveRecord::Base
  has_many :payments, :dependent => :destroy
  
  validates_presence_of :name
  validates_presence_of :description
  validates_numericality_of :price_cents
  
  before_destroy :check_for_payments
  
  def check_for_payments
    if( self.payments.size > 0 )
      raise NotDeletableEventException.new("It has payments")
    end
  end
  
  def is_paid_for_user?( user_id )
    if !Payment.find_by_event_id_and_user_id( self.id, user_id ).nil?
      return true
    else
      return false
    end
  end
end

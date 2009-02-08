class NotDeletableEventException < Exception
end

class Event < ActiveRecord::Base
  permalink :name

  has_many :carts_events #, :dependent => :destroy
  has_many :carts, :through => :carts_events
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description
  validates_numericality_of :price_cents

  simple_text_fields
  
  before_destroy :check_for_payments
  
  def check_for_payments
    if( !self.carts.empty? )
      raise NotDeletableEventException.new("It has payments")
    end
  end
  
  def is_paid_for_user?( user_id )
    self.carts.purchased.exists?( :user_id => user_id )
  end
  
  def price_euros
    Utils.cents_to_euros( self.price_cents )
  end
end

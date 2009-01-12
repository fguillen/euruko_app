class PaymentNotification < ActiveRecord::Base
  serialize :params
  after_create :create_payments
  
  def create_payments
    
  end
end

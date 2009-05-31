class Cart < ActiveRecord::Base
  has_many :carts_events, :dependent => :destroy
  has_many :events, :through => :carts_events
  
  belongs_to :user

  has_one :invoice
  
  serialize :paypal_notify_params
  serialize :paypal_complete_params
  serialize :paypal_errors
    
  validates_presence_of :user_id
  validates_presence_of :status
  
  attr_protected :params, :status, :transaction_id, :purchased_at, :user_id
  
  before_validation_on_create :initialize_status
  
  STATUS = {
    :ON_SESSION       => 'On Session',
    :COMPLETED        => 'Completed',
    :NOT_NOTIFIED     => 'Not Notified by PayPal',
    :PAYPAL_ERROR     => 'PayPal Error'
  }
  
  named_scope :purchased, :conditions => { :status => Cart::STATUS[:COMPLETED] }
  
  def paypal_encrypted( return_url, notify_url )
    values = {
      :business       => APP_CONFIG[:paypal_seller],
      :cmd            => '_cart',
      :upload         => 1,
      :return         => return_url,
      :invoice        => self.id,
      :notify_url     => notify_url,
      :currency_code  => 'EUR',
      :cert_id        => APP_CONFIG[:paypal_cert_id],
      :lc             => 'US'
    }
    
    self.events.each_with_index do |event, index|
      values.merge!({
        "amount_#{index+1}"       => event.price_euros,
        "item_name_#{index+1}"    => event.name,
        "item_number_#{index+1}"  => event.id,
        "quantity_#{index+1}"     => 1
      })
    end

    Cart.encrypt_for_paypal(values)
  end

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

  def self.encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end
  
  def total_price
    self.events.sum(:price_cents)
  end
  
  def total_price_on_euros
    Utils.cents_to_euros( self.events.sum(:price_cents) )
  end
  
  def self.retrieve_on_sesion_or_new( user_id )
    @cart = Cart.find( :first, :conditions => ["user_id = ? and status = ?", user_id, Cart::STATUS[:ON_SESSION]] )
    @cart = User.find( user_id ).carts.create!()  if @cart.nil?
    
    return @cart
  end
  
  def is_purchased?
    # Cart.purchased.exists?( self.id )
    return (self.status == Cart::STATUS[:COMPLETED])
  end
  
  def paypal_notificate( params )
    self.paypal_notify_params  = params
    self.paypal_status         = params[:payment_status]
    self.transaction_id        = params[:txn_id]
    
    self.paypal_errors = []
    self.paypal_errors << "status not equal: #{Cart::STATUS[:COMPLETED]}, #{params[:payment_status]}"            if params[:payment_status] != Cart::STATUS[:COMPLETED]  
    self.paypal_errors << "secret not equal: #{APP_CONFIG[:paypal_secret]}, #{params[:secret]}"                  if params[:secret]         != APP_CONFIG[:paypal_secret]  
    self.paypal_errors << "receiver_email not equal: #{APP_CONFIG[:paypal_seller]}, #{params[:receiver_email]}"  if params[:receiver_email] != APP_CONFIG[:paypal_seller] 
    self.paypal_errors << "mc_gross not equal: #{self.total_price_on_euros}, #{params[:mc_gross]}"               if params[:mc_gross]       != self.total_price_on_euros
    self.paypal_errors << "mc_currency not equal: EUR, #{params[:mc_currency]}"                                  if params[:mc_currency]    != "EUR"

    if self.paypal_errors.empty?
      self.paypal_errors  = nil
      self.purchased_at   = Time.now
      self.status         = Cart::STATUS[:COMPLETED]
    else
      self.status         = Cart::STATUS[:PAYPAL_ERROR]
    end
    
    self.save!
    
    # email notifications
    self.send_email_notifications
    
    # twitter notification
    # self.send_twitter_notifications
  end

  def send_email_notifications
    if self.is_purchased?
      SystemMailer.deliver_cart_purchased_ok_to_user( self )
      SystemMailer.deliver_cart_purchased_ok_to_admin( self )
    else
      SystemMailer.deliver_cart_purchased_error_to_user( self )
      SystemMailer.deliver_cart_purchased_error_to_admin( self )
    end
  end
  
  def send_twitter_notifications
    return  if !self.is_purchased?
    
    self.events.each do |event|
      remaining_capacity = event.remaining_capacity
      
      if( remaining_capacity <= 0 )
        begin
          TwitterWrapper.post( "#{event.name} SOLD OUT!" )
        rescue Exception => e 
          logger.error( "Error trying to post on twitter: #{e}" )
        end       
      elsif( ( remaining_capacity % APP_CONFIG[:twitter_notification_step].to_i ) == 0 )
        begin
          TwitterWrapper.post( "Only #{remaining_capacity} places available on #{event.name}" )
        rescue Exception => e 
          logger.error( "Error trying to post on twitter: #{e}" )
        end
      end
    end
  end
  
  def events_out_of_capacity
    _events_out_of_capacity = []
    self.events.each do |event|
      _events_out_of_capacity << event  if event.out_of_capacity?
    end
    
    return _events_out_of_capacity
  end
  
  private
    def initialize_status
      self.status ||= STATUS[:ON_SESSION]
    end
end

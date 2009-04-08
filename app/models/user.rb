require 'digest/sha1'

class User < ActiveRecord::Base
  permalink :name
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :speakers,   :dependent => :destroy
  has_many :votes,      :dependent => :destroy
  has_many :comments,   :dependent => :destroy
  has_many :attendees,  :dependent => :destroy
  has_many :resources,  :dependent => :destroy
  has_many :carts,      :dependent => :destroy
  has_many :owned_papers, :class_name => 'Paper', :foreign_key => 'creator_id', :dependent => :nullify

  has_many :speaker_on,   :through => :speakers,  :source => :paper
  has_many :attendee_to,    :through => :attendees,   :source => :paper

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :name
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  validates_uniqueness_of   :name

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of     :password,              :if => :change_password, :on => :update
  validates_presence_of     :password_confirmation, :if => :change_password, :on => :update
  
  # validates_inclusion_of    :public_profile, :in => [true, false]
  
  validates_format_of       :company_url,       :with => /^(http|https|ftp):\/\/.*\..*/, :if => lambda { |user| !user.company_url.blank? }
  validates_format_of       :personal_web_url,  :with => /^(http|https|ftp):\/\/.*\..*/, :if => lambda { |user| !user.personal_web_url.blank? }
  validates_presence_of     :personal_web_url, 
                            :if => lambda { |user| !user.personal_web_name.blank? },
                            :message => "can't be blank if you have defined a 'personal web name'"

  simple_text_fields
  
  before_create :make_activation_code 
  before_create :update_role
  after_create  :send_password_if_forgotten
  
  named_scope :public_profile, :conditions => { :public_profile => true }
  named_scope :activated, :conditions => 'activated_at IS NOT NULL'
  named_scope :speaker, :joins => 'join speakers on speakers.user_id = users.id', :group => 'users.id'
  named_scope(
    :public_speaker, 
    :joins => "join speakers on speakers.user_id = users.id join papers on speakers.paper_id = papers.id and papers.status in ('#{Paper::STATUS[:ACEPTED]}','#{Paper::STATUS[:CONFIRMED]}')", 
    :group => 'users.id'
  )
  named_scope :ordered, :order => 'name asc'
  named_scope(
    :has_paid, 
    lambda{ |*args| {
      :joins => 'join carts on carts.user_id = users.id join carts_events on carts_events.cart_id = carts.id', 
      :conditions => ["carts.status = 'Completed' and carts_events.event_id = ?", args.first] 
    }}
  )
    
  #   carts.purchased.exists?( :user_id => user_id )
  #   
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible(
    :login, 
    :email, 
    :name, 
    :password, 
    :password_confirmation,
    :change_password,
    :text,
    :personal_web_name,
    :personal_web_url,
    :company_name,
    :company_url,
    :public_profile,
    :permalink_field_name,
    :github_user,
    :twitter_user,
    :location_name,
    :location_country,
    :invoice_info
  )

  attr_accessor :change_password
  
  cattr_reader :per_page
  @@per_page = 48


  # CONSTANTS
  ROLE = {
    :USER   => "User",
    :ADMIN  => "Admin"
  }
  
  def change_password=(value)
    @change_password = (value == '1' ? true : false)
  end
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  def validate
    errors.add(:public_profile, "You can't have a private profile because you are registered as a speaker") if speakers.any? && !public_profile?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    # logger.debug( "authenticate( #{login}, #{password} )" )
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    # logger.debug( "u: #{u.inspect} ")
    # logger.debug( "aut: #{u.authenticated?(password)}")
    # logger.debug( "cryt: #{u.crypted_password}")
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def admin?
    self.role == User::ROLE[:ADMIN]
  end

  # def self.retrieve_users( user_who_ask_for )
  #   return User.activated.public_profile   if !user_who_ask_for.admin?
  #   return User.all                        if user_who_ask_for.admin?
  # end
  # 
  # def self.retrieve_speakers( user_who_ask_for )
  #   return Paper.visible.collect(&:speakers).flatten.collect(&:user).uniq  if !user_who_ask_for.admin?
  #   return Paper.all.collect(&:speakers).flatten.collect(&:user).uniq      if user_who_ask_for.admin?
  # end
  
  def speaker?
    !self.speaker_on.empty?
  end
  
  def is_speaker_on?( paper )
    Speaker.exists?( :paper_id => paper.id, :user_id => self.id )
  end
  
  def is_speaker_on_or_admin?( paper )
    ( self.admin? || self.is_speaker_on?( paper ) )
  end
  
  # if current_user admin show all users
  # if not only public
  def speaker_on_visibles_for_user( user )
    return self.speaker_on.visible  if self != user
    return self.speaker_on          if self == user || user.admin?
  end

  def forgot_password
#    @forgotten_password = true
    self.make_password_reset_code
    UserMailer.deliver_forgotten_password(self)# if recently_forgot_password?    
  end

  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    UserMailer.deliver_reset_password(self)# if recently_reset_password?
#    @reset_password = true
  end

  def recently_reset_password?
    @reset_password
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def send_password_if_forgotten
#    UserNotifier.deliver_forgot_password(self) if recently_forgot_password?
#    UserNotifier.deliver_reset_password(self) if recently_reset_password?
  end
  
  alias_method :ar_to_xml, :to_xml
  def to_xml(options = {})
    default_except = [
      :activated_at,
      :activation_code,
      :email,
      :login,
      :password_reset_code,
      :permalink,
      :public_profile,
      :role,
      :crypted_password, 
      :salt, 
      :remember_token, 
      :remember_token_expires_at, 
      :created_at, 
      :updated_at,
      :invoice_info
    ]
    options[:except] = (options[:except] ? options[:except] + default_except : default_except)   
    self.ar_to_xml( options )
  end
  
  def everything_paid?
    anything_to_pay = true
    
    Event.all.each do |event|
      if !event.is_paid_for_user?( self )
        anything_to_pay = false
        break
      end
    end
    
    return anything_to_pay
  end

  protected

    def make_password_reset_code
     self.update_attribute :password_reset_code, Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def make_activation_code
      self.activation_code = self.class.make_token
    end
    
    def update_role
      self.role = User::ROLE[:USER]
    end

end

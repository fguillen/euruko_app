class UsersController < ApplicationController
  before_filter :login_required,                    :except => [:index, :show, :new, :create, :activate, :forgot_password, :reset_password]
  before_filter :load_user,                         :except => [:index, :new, :create, :activate, :forgot_password, :reset_password]
  before_filter :should_be_current_user_or_admin,   :except => [:index, :show, :new, :create, :activate, :forgot_password, :reset_password]

  # GET /users
  # GET /users.xml
  def index
    if( !params[:search].blank? && params[:search] == 'speakers' )
      @users = User.ordered.speaker          if admin?
      @users = User.ordered.public_speaker   if !admin?
      
    elsif( 
      !params[:search].blank? && 
      params[:search] == 'event_attendees' &&
      !params[:event_id].blank?
    )
      @users = User.ordered.has_paid( params[:event_id] )                 if admin?
      @users = User.ordered.public_profile.has_paid( params[:event_id] )  if !admin?
      
    else
      @users = User.ordered                            if admin?
      @users = User.ordered.activated.public_profile   if !admin?
      
    end

    @users = @users.paginate( :page => params[:page] )  if params[:page]

    respond_to do |format|
      format.html
      format.xml { render :xml => @users }
      format.csv { render :csv => @users, :layout => false }
      format.pdf do 
        send_data( 
          PDFGenerator.users_list(@users, current_user), 
          :type => 'application/pdf',
          :filename => "people.pdf", # TODO: use the helper.user_index_title method
          :disposition => 'inline'
        )
      end
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if( !@user.public_profile && current_user != @user && !admin? )
      @user = nil
      record_not_found
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  def new
    @user = User.new
    @user.public_profile = true
  end
 
  def create
    logout_keeping_session!
    
    @user = User.new(params[:user])
    
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! You have been autologged."
      self.current_user = user
      redirect_back_or_default('/')
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    logger.info("XXX:1: #{params[:user][:password]}")
    if params[:user][:change_password] == "0"
      params[:user][:password] = nil
      params[:user][:password_confirmation] = nil
    end

    logger.info("XXX:2: #{params[:user][:password]}")
    
    if admin? && params[:user][:role]
      @user.role = params[:user][:role]
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        flash[:error] = 'Some error trying to update the profile'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def forgot_password
    return unless request.post?
    if @user = User.activated.find_by_email(params[:email])
      @user.forgot_password
      redirect_to(login_path)
      flash[:notice] = "You will receive an email to reset your password." 
    else
      flash[:error] = "No user activated found with email #{params[:email]}"
    end
  end

  def reset_password
    @user = User.activated.find_by_password_reset_code(params[:id])  unless params[:id].nil?
    
    if @user.nil? 
      record_not_found
    else
      return unless request.post? && !params[:password].blank?
      @user.password                = params[:password]
      @user.password_confirmation   = params[:password_confirmation]
      @user.password_reset_code     = nil
      if @user.save
        flash[:notice] = "You have changed your password successfully, use it to log in."
        redirect_to login_path
      end
    end
  end
  
  private
    def load_user
      @user = User.find(params[:id])
    end
    
    def should_be_current_user_or_admin
      if( !admin? and current_user != @user )
        record_not_found
      end
    end
end

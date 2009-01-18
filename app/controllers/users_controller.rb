class UsersController < ApplicationController
  before_filter :login_required,                    :except => [:index, :show, :new, :create]
  before_filter :load_user,                         :except => [:index, :new, :create]
  before_filter :should_be_current_user_or_admin,   :except => [:index, :show, :new, :create]

  # GET /users
  # GET /users.xml
  def index
    if( params[:speakers] )
      @users = User.find_speakers
    else
      @users = User.find_public   if !admin?
      @users = User.all           if admin?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
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
  end
 
  def create
    logout_keeping_session!
    
    @user = User.new(params[:user])
    @user.role ||= User::ROLE[:USER]
    
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
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
    respond_to do |format|
      if @user.update_attributes(params[:user])
        
        if admin?
          @user.role = params[:user][:role]
          @user.save!
        end
        
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    def load_user
      @user = User.find_by_id!(params[:id])
    end
    
    def should_be_current_user_or_admin
      if( !admin? and current_user.id != @user.id )
        record_not_found
      end
    end
end

class PapersController < ApplicationController
  before_filter :login_required,            :only => [:new, :edit, :update, :create, :update_status, :destroy ]
  before_filter :load_paper_by_id,          :only => [:show, :edit, :update, :update_status, :destroy]
  before_filter :speaker_or_admin_required, :only => [:edit, :update, :update_status, :destroy ]
  before_filter :admin_required,            :only => [:destroy]
  before_filter :public_profile_required,   :only => [:new]
  before_filter :admin_or_not_under_review_required, :only => [:edit, :update]

  def index
    @conditions = {}
    
    if !params[:status].blank?
      @conditions = { :status => params[:status] }
    end    
    
    @papers = Paper.date_ordered                      if admin?
    @papers = Paper.visible.not_break.date_ordered    if !admin?
    
    @papers = @papers.all( :conditions => @conditions, :order => 'date asc' )
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end

  def show
    if( !@paper.can_see_it?(current_user) )
      @paper = nil
      record_not_found
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @paper }
      end
    end    
  end

  def new
    @paper = Paper.new
    @paper.family = Paper::FAMILY[:SESSION]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper }
    end
  end


  def edit
    @resource = Resource.new
  end

  def create
    @paper            = Paper.new( params[:paper] )
    @paper.creator_id = current_user.id
    @paper.fill_admin(params[:paper])  if admin?

    respond_to do |format|
      if @paper.save
        @paper.speakers.create!( :user => current_user )  unless admin?

        flash[:notice] = "Paper was successfully created. Now you can complete the Paper information, or do it later if you don't have now all the information needed."
        format.html { redirect_to edit_paper_path(@paper) }
        format.xml  { render :xml => @paper, :status => :created, :location => @paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @paper.fill_admin(params[:paper])  if admin?
    
    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        flash[:notice] = 'Paper was successfully updated.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Some error trying to update the Paper."
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_status
    if( @paper.can_change_status_to?( current_user, params[:status] ) )
      @paper.status = params[:status]
    end
    
    respond_to do |format|
      if @paper.save
        flash[:notice] = 'Paper was successfully updated.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Some error trying to update the status of the Paper."
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @paper.destroy

    respond_to do |format|
      flash[:notice] = "The Paper has been removed."
      format.html { redirect_to(papers_path) }
      format.xml  { head :ok }
    end
  end
  
  private
    def public_profile_required
      if !current_user.public_profile
        flash[:error] = "You can't not access to this action unless you set your profile as public"
        redirect_to edit_user_path( current_user )
      end
    end
    
    def admin_or_not_under_review_required
      if !admin? && @paper.status == Paper::STATUS[:UNDER_REVIEW]
        flash[:error] = "The paper is under review, now it can not be updated"
        redirect_to paper_path( @paper )
      end
    end
end

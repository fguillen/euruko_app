class StaticPagesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :admin_required, :except => [:index, :show]
  before_filter :load_static_page, :only => [:destroy, :update, :edit, :show]
  
  # GET /static_pages
  # GET /static_pages.xml
  def index
    @static_pages = StaticPage.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @static_pages }
    end
  end

  # GET /static_pages/1
  # GET /static_pages/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @static_page }
    end
  end

  # GET /static_pages/new
  # GET /static_pages/new.xml
  def new
    @static_page = StaticPage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @static_page }
    end
  end

  # GET /static_pages/1/edit
  def edit
  end

  # POST /static_pages
  # POST /static_pages.xml
  def create
    @static_page = StaticPage.new(params[:static_page])

    respond_to do |format|
      if @static_page.save
        flash[:notice] = 'StaticPage was successfully created.'
        format.html { redirect_to(@static_page) }
        format.xml  { render :xml => @static_page, :status => :created, :location => @static_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @static_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /static_pages/1
  # PUT /static_pages/1.xml
  def update
    respond_to do |format|
      if @static_page.update_attributes(params[:static_page])
        flash[:notice] = 'StaticPage was successfully updated.'
        format.html { redirect_to(@static_page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @static_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /static_pages/1
  # DELETE /static_pages/1.xml
  def destroy
    @static_page.destroy
    flash[:notice] = 'StaticPage was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to(static_pages_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def load_static_page
      @static_page = StaticPage.find_by_permalink(params[:id])
      record_not_found  unless @static_page
    end
end

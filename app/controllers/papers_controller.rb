class PapersController < ApplicationController
  
  before_filter :load_paper_by_id, :only => [:show, :edit, :update, :update_status, :destroy]
  
  # GET /papers
  # GET /papers.xml
  def index
    @papers = Paper.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end

  # GET /papers/1
  # GET /papers/1.xml
  def show
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/new
  # GET /papers/new.xml
  def new
    @paper = Paper.new
    @paper.family = Paper::FAMILY[:SESSION]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/1/edit
  def edit
  end

  # POST /papers
  # POST /papers.xml
  def create
    @paper = Paper.new( params[:paper] )
    @paper.status = Paper::STATUS[:PROPOSED]
    # @paper.add_speaker( current_user )

    respond_to do |format|
      if @paper.save
        flash[:notice] = 'Paper was successfully created.'
        format.html { redirect_to(@paper) }
        format.xml  { render :xml => @paper, :status => :created, :location => @paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /papers/1
  # PUT /papers/1.xml
  def update
    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        flash[:notice] = 'Paper was successfully updated.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Some error trying to update the Paper: #{paper.errors.full_messages}."
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_status
    @paper.status = params[:status]
    
    respond_to do |format|
      if @paper.save
        flash[:notice] = 'Status Paper was successfully updated.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Some error trying to update the status of the Paper: #{paper.errors.full_messages}."
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.xml
  def destroy
    @paper.destroy

    respond_to do |format|
      format.html { redirect_to(papers_url) }
      format.xml  { head :ok }
    end
  end
end

class SpeakersController < ApplicationController
  # GET /speakers
  # GET /speakers.xml
  def index
    @speakers = Speaker.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @speakers }
    end
  end

  # GET /speakers/1
  # GET /speakers/1.xml
  def show
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @speaker }
    end
  end

  # GET /speakers/new
  # GET /speakers/new.xml
  def new
    @speaker = Speaker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @speaker }
    end
  end

  # GET /speakers/1/edit
  def edit
    @speaker = Speaker.find(params[:id])
  end

  # POST /speakers
  # POST /speakers.xml
  def create
    @speaker = Speaker.new(params[:speaker])

    respond_to do |format|
      if @speaker.save
        flash[:notice] = 'Speaker was successfully created.'
        format.html { redirect_to(@speaker) }
        format.xml  { render :xml => @speaker, :status => :created, :location => @speaker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @speaker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /speakers/1
  # PUT /speakers/1.xml
  def update
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      if @speaker.update_attributes(params[:speaker])
        flash[:notice] = 'Speaker was successfully updated.'
        format.html { redirect_to(@speaker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @speaker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /speakers/1
  # DELETE /speakers/1.xml
  def destroy
    @speaker = Speaker.find(params[:id])
    @speaker.destroy

    respond_to do |format|
      format.html { redirect_to(speakers_url) }
      format.xml  { head :ok }
    end
  end
end

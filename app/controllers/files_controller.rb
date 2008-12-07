class FilesController < ApplicationController
  # GET /files
  # GET /files.xml
  def index
    @files = File.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @files }
    end
  end

  # GET /files/1
  # GET /files/1.xml
  def show
    @file = File.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @file }
    end
  end

  # GET /files/new
  # GET /files/new.xml
  def new
    @file = File.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @file }
    end
  end

  # GET /files/1/edit
  def edit
    @file = File.find(params[:id])
  end

  # POST /files
  # POST /files.xml
  def create
    @file = File.new(params[:file])

    respond_to do |format|
      if @file.save
        flash[:notice] = 'File was successfully created.'
        format.html { redirect_to(@file) }
        format.xml  { render :xml => @file, :status => :created, :location => @file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /files/1
  # PUT /files/1.xml
  def update
    @file = File.find(params[:id])

    respond_to do |format|
      if @file.update_attributes(params[:file])
        flash[:notice] = 'File was successfully updated.'
        format.html { redirect_to(@file) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /files/1
  # DELETE /files/1.xml
  def destroy
    @file = File.find(params[:id])
    @file.destroy

    respond_to do |format|
      format.html { redirect_to(files_url) }
      format.xml  { head :ok }
    end
  end
end

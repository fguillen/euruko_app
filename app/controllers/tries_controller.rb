class TriesController < ApplicationController
  # GET /tries
  # GET /tries.xml
  def index
    @tries = Try.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tries }
    end
  end

  # GET /tries/1
  # GET /tries/1.xml
  def show
    @try = Try.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @try }
    end
  end

  # GET /tries/new
  # GET /tries/new.xml
  def new
    @try = Try.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @try }
    end
  end

  # GET /tries/1/edit
  def edit
    @try = Try.find(params[:id])
  end

  # POST /tries
  # POST /tries.xml
  def create
    @try = Try.new(params[:try])

    respond_to do |format|
      if @try.save
        flash[:notice] = 'Try was successfully created.'
        format.html { redirect_to(@try) }
        format.xml  { render :xml => @try, :status => :created, :location => @try }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @try.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tries/1
  # PUT /tries/1.xml
  def update
    @try = Try.find(params[:id])

    respond_to do |format|
      if @try.update_attributes(params[:try])
        flash[:notice] = 'Try was successfully updated.'
        format.html { redirect_to(@try) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @try.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tries/1
  # DELETE /tries/1.xml
  def destroy
    @try = Try.find(params[:id])
    @try.destroy

    respond_to do |format|
      format.html { redirect_to(tries_url) }
      format.xml  { head :ok }
    end
  end
end

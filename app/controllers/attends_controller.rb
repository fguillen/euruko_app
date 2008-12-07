class AttendsController < ApplicationController
  # GET /attends
  # GET /attends.xml
  def index
    @attends = Attend.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attends }
    end
  end

  # GET /attends/1
  # GET /attends/1.xml
  def show
    @attend = Attend.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attend }
    end
  end

  # GET /attends/new
  # GET /attends/new.xml
  def new
    @attend = Attend.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attend }
    end
  end

  # GET /attends/1/edit
  def edit
    @attend = Attend.find(params[:id])
  end

  # POST /attends
  # POST /attends.xml
  def create
    @attend = Attend.new(params[:attend])

    respond_to do |format|
      if @attend.save
        flash[:notice] = 'Attend was successfully created.'
        format.html { redirect_to(@attend) }
        format.xml  { render :xml => @attend, :status => :created, :location => @attend }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attend.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attends/1
  # PUT /attends/1.xml
  def update
    @attend = Attend.find(params[:id])

    respond_to do |format|
      if @attend.update_attributes(params[:attend])
        flash[:notice] = 'Attend was successfully updated.'
        format.html { redirect_to(@attend) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attend.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attends/1
  # DELETE /attends/1.xml
  def destroy
    @attend = Attend.find(params[:id])
    @attend.destroy

    respond_to do |format|
      format.html { redirect_to(attends_url) }
      format.xml  { head :ok }
    end
  end
end

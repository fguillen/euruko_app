class ReportersController < ApplicationController
  # GET /reporters
  # GET /reporters.xml
  def index
    @reporters = Reporter.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reporters }
    end
  end

  # GET /reporters/1
  # GET /reporters/1.xml
  def show
    @reporter = Reporter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reporter }
    end
  end

  # GET /reporters/new
  # GET /reporters/new.xml
  def new
    @reporter = Reporter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reporter }
    end
  end

  # GET /reporters/1/edit
  def edit
    @reporter = Reporter.find(params[:id])
  end

  # POST /reporters
  # POST /reporters.xml
  def create
    @reporter = Reporter.new(params[:reporter])

    respond_to do |format|
      if @reporter.save
        flash[:notice] = 'Reporter was successfully created.'
        format.html { redirect_to(@reporter) }
        format.xml  { render :xml => @reporter, :status => :created, :location => @reporter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reporter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reporters/1
  # PUT /reporters/1.xml
  def update
    @reporter = Reporter.find(params[:id])

    respond_to do |format|
      if @reporter.update_attributes(params[:reporter])
        flash[:notice] = 'Reporter was successfully updated.'
        format.html { redirect_to(@reporter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reporter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reporters/1
  # DELETE /reporters/1.xml
  def destroy
    @reporter = Reporter.find(params[:id])
    @reporter.destroy

    respond_to do |format|
      format.html { redirect_to(reporters_url) }
      format.xml  { head :ok }
    end
  end
end

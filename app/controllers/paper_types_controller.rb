class PaperTypesController < ApplicationController
  # GET /paper_types
  # GET /paper_types.xml
  def index
    @paper_types = PaperType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paper_types }
    end
  end

  # GET /paper_types/1
  # GET /paper_types/1.xml
  def show
    @paper_type = PaperType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper_type }
    end
  end

  # GET /paper_types/new
  # GET /paper_types/new.xml
  def new
    @paper_type = PaperType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper_type }
    end
  end

  # GET /paper_types/1/edit
  def edit
    @paper_type = PaperType.find(params[:id])
  end

  # POST /paper_types
  # POST /paper_types.xml
  def create
    @paper_type = PaperType.new(params[:paper_type])

    respond_to do |format|
      if @paper_type.save
        flash[:notice] = 'PaperType was successfully created.'
        format.html { redirect_to(@paper_type) }
        format.xml  { render :xml => @paper_type, :status => :created, :location => @paper_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paper_types/1
  # PUT /paper_types/1.xml
  def update
    @paper_type = PaperType.find(params[:id])

    respond_to do |format|
      if @paper_type.update_attributes(params[:paper_type])
        flash[:notice] = 'PaperType was successfully updated.'
        format.html { redirect_to(@paper_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paper_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paper_types/1
  # DELETE /paper_types/1.xml
  def destroy
    @paper_type = PaperType.find(params[:id])
    @paper_type.destroy

    respond_to do |format|
      format.html { redirect_to(paper_types_url) }
      format.xml  { head :ok }
    end
  end
end

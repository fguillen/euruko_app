class ResourcesController < ApplicationController
  before_filter :login_required
  before_filter :load_paper_by_paper_id
  before_filter :speaker_or_admin_required
  
  # POST /resources
  # POST /resources.xml
  def create
    # diference between a upload file on the application
    # or a resource url on other place
    url = params[:resource][:url]
    is_local = false
    
    if( !params[:resource][:file].blank? )
      url = Resource.save_file( @paper.id, params[:resource][:file] )
      is_local = true
    end
    
    @resource =
      Resource.new(
        :url      => url,
        :paper    => @paper,
        :user     => current_user,
        :is_local => is_local,
        :name     => params[:resource][:name]
      )
    
    # puts @resource.valid?
    # puts @resource.errors.full_messages
      
    respond_to do |format|
      if @resource.save
        flash[:notice] = 'Resource was successfully created.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @resource, :status => :created, :location => @resource }
      else
        flash[:error] = "Error creating Resource: #{@resource.errors.full_messages}"
        format.html { render :template => 'papers/edit' }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      flash[:notice] = 'Resource was successfully deleted.'
      format.html { redirect_to( edit_paper_path(@paper) ) }
      format.xml  { head :ok }
    end
  end
end

class PhotosController < ApplicationController
  before_filter :login_required
  before_filter :load_paper_by_paper_id
  before_filter :speaker_or_admin_required, :only => [:create]

  
  def create
    logger.debug( "photos_controller.create, @paper.photo.url:#{@paper.photo.url}" )
    @paper.photo = params[:file]
    logger.debug( "photos_controller.create, @paper.photo.url:#{@paper.photo.url}" )
    
    respond_to do |format|
      if @paper.save
        logger.debug( "photos_controller.create, @paper.photo.url:#{@paper.photo.url}" )
        
        flash[:notice] = 'Photo was successfully uploaded.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Some error trying to upload the photo of the Paper: #{@paper.errors.full_messages}."
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end

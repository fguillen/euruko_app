class SpeakersController < ApplicationController
  before_filter :login_required
  before_filter :load_paper_by_paper_id, :only => [:create, :destroy]
  before_filter :speaker_or_admin_required


  # POST /speakers
  # POST /speakers.xml
  def create
    @speaker =
      Speaker.new(
        :paper    => @paper,
        :user_id  => params[:speaker][:user_id]
      )

    respond_to do |format|
      if @speaker.save
        flash[:notice] = 'Speaker was successfully created.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @speaker, :status => :created, :location => @speaker }
      else
        flash[:error] = "Error trying to adding an speaker to the paper: #{@speaker.errors.full_messages}."
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @speaker.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /speakers/1
  # DELETE /speakers/1.xml
  def destroy
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      if @speaker.destroy
        flash[:notice] = 'Speaker was successfully eliminated.'
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error trying to eliminating an speaker to the paper: #{@speaker.errors.full_messages}."
        format.html { redirect_to( edit_paper_path(@paper) ) }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end
  

end

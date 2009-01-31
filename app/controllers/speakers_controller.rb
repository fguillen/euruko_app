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
        format.html do
          flash[:notice] = 'Speaker was successfully created.'          
          redirect_to( edit_paper_path(@paper) )
        end
        format.xml  { render :xml => @speaker, :status => :created, :location => @speaker }
        format.js   { render :partial => 'papers/speakers_edit', :locals => { :paper => @paper } }
      else
        format.html do
          flash[:error] = "Error trying to adding an speaker to the paper: #{@speaker.errors.full_messages}."
          redirect_to( edit_paper_path(@paper) )
        end
        format.xml  { render :xml => @speaker.errors, :status => :unprocessable_entity }
        format.js   { render :partial => 'papers/speakers_edit', :locals => { :paper => @paper }, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /speakers/1
  # DELETE /speakers/1.xml
  def destroy
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      if @speaker.destroy
        format.html do
          flash[:notice] = 'Speaker was successfully eliminated.'
          redirect_to( edit_paper_path(@paper) )
        end
        format.xml  { head :ok }
        format.js   { render :partial => 'papers/speakers_edit', :locals => { :paper => @paper } }
      else
        format.html do
          flash[:error] = "Error trying to eliminating an speaker to the paper: #{@speaker.errors.full_messages}."
          redirect_to( edit_paper_path(@paper) )
        end
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
        format.js   { render :partial => 'papers/speakers_edit', :locals => { :paper => @paper }, :status => :unprocessable_entity }
      end
    end
  end
  

end

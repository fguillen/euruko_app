class AttendeesController < ApplicationController
  before_filter :login_required
  before_filter :load_paper_by_paper_id

  # POST /attendees
  # POST /attendees.xml
  def create
    @attendee = current_user.attendees.build( :paper => @paper )

    respond_to do |format|
      if @attendee.save
        flash[:notice] = 'Attendee was successfully created.'
        format.html { redirect_to paper_path(@paper) }
        format.xml  { render :xml => @attendee, :status => :created, :location => @attendee }
      else
        flash[:notice] = 'Error trying to delete Attendee.'
        format.html { redirect_to paper_path(@paper) }
        format.xml  { render :xml => @attendee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1
  # DELETE /attendees/1.xml
  def destroy
    @attendee = current_user.attendees.find_by_id!(params[:id])
    @attendee.destroy

    respond_to do |format|
      flash[:notice] = 'Attendee correctly deleted.'
      format.html { redirect_to paper_path(@paper) }
      format.xml  { head :ok }
    end
  end
end

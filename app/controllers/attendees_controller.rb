class AttendeesController < ApplicationController
  before_filter :login_required
  before_filter :load_paper_by_paper_id

  # POST /attendees
  # POST /attendees.xml
  def create
    @attendee = current_user.attendees.build( :paper => @paper )

    respond_to do |format|
      if @attendee.save
        format.html do 
          flash[:notice] = 'Attendee was successfully created.'
          redirect_to paper_path(@paper)
        end
        format.xml  { render :xml => @attendee, :status => :created, :location => @attendee }
        format.js   { render :partial => 'papers/attendees' }
      else
        format.html do
          flash[:notice] = 'Error trying to create Attendee.'
          redirect_to paper_path(@paper)
        end
        format.xml  { render :xml => @attendee.errors, :status => :unprocessable_entity }
        format.js   { render :text => 'Some error ocurred', :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1
  # DELETE /attendees/1.xml
  def destroy
    @attendee = current_user.attendees.find_by_id!(params[:id])
    @attendee.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = 'Attendee correctly deleted.'
        redirect_to paper_path(@paper)
      end
      format.xml  { head :ok }
      format.js   { render :partial => 'papers/attendees' }
    end
  end
end

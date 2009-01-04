class AttendeesController < ApplicationController

  before_filter :load_paper_by_paper_id

  # POST /attendees
  # POST /attendees.xml
  def create
    puts current_user
    
    @attendee = 
      Attendee.new(
        :paper  => @paper,
        :user   => current_user
      )
      
    puts @attendee.valid?
    puts @attendee.errors.full_messages 

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
    @attendee = Attendee.find(params[:id])
    @attendee.destroy

    respond_to do |format|
      flash[:notice] = 'Attendee correctly deleted.'
      format.html { redirect_to paper_path(@paper) }
      format.xml  { head :ok }
    end
  end
end

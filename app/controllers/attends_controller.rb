class AttendsController < ApplicationController

  before_filter :load_paper_by_paper_id

  # POST /attends
  # POST /attends.xml
  def create
    @attend = 
      Attend.new(
        :paper  => @paper,
        :user   => current_user
      )
      
    puts @attend.valid?
    puts @attend.errors.full_messages 

    respond_to do |format|
      if @attend.save
        flash[:notice] = 'Attend was successfully created.'
        format.html { redirect_to paper_path(@paper) }
        format.xml  { render :xml => @attend, :status => :created, :location => @attend }
      else
        flash[:notice] = 'Error trying to delete Attend.'
        format.html { redirect_to paper_path(@paper) }
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
      flash[:notice] = 'Attend correctly deleted.'
      format.html { redirect_to paper_path(@paper) }
      format.xml  { head :ok }
    end
  end
end

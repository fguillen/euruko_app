class VotesController < ApplicationController

  before_filter :load_paper_by_paper_id
  
  # POST /votes
  # POST /votes.xml
  def create
    @vote = 
      Vote.new( 
        :points => params[:points].to_i,
        :paper  => @paper,
        :user   => current_user
      )

    respond_to do |format|
      if @vote.save
        flash[:notice] = 'Vote was successfully created.'
        format.html { redirect_to( @paper ) }
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        flash[:error] = "Error trying to vote the paper: #{@vote.errors.full_messages}."
        format.html { redirect_to( @paper ) }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = 
      Vote.find_by_paper_id_and_user_id(
        params[:paper_id], 
        current_user.id
      )

    respond_to do |format|
      if @vote.update_attributes( :points => params[:points] )
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to( @paper ) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error trying to update the vote: #{@vote.errors.full_messages}."        
        format.html { redirect_to( @paper ) }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end
end

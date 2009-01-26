class VotesController < ApplicationController
  before_filter :login_required
  before_filter :load_paper_by_paper_id
  
  # POST /votes
  # POST /votes.xml
  def create
    @vote = Vote.find_by_paper_id_and_user_id( @paper.id, current_user.id )

    if @vote.nil?
      @vote = current_user.votes.build( :paper  => @paper )
    end

    @vote.update_attributes( :points => params[:points].to_i )
    
    respond_to do |format|
      if @vote.save
        format.html do
          flash[:notice] = 'Vote was successfully sended.'
          redirect_to( @paper ) 
        end
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
        format.js   { render :partial => 'papers/valorations' }
      else
        format.html do
          flash[:error] = "Error trying to vote the paper: #{@vote.errors.full_messages}."
          redirect_to( @paper )
        end
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
        format.js   { render :text => 'On error ocurred!' }
      end
    end
  end

  # # PUT /votes/1
  # # PUT /votes/1.xml
  # def update
  #   logger.debug( "XXX: on update" )
  #   @vote = current_user.votes.find_by_paper_id!( params[:paper_id].to_i )
  # 
  #   respond_to do |format|
  #     if @vote.update_attributes( :points => params[:points].to_i )
  #       flash[:notice] = 'Vote was successfully updated.'
  #       format.html { redirect_to( @paper ) }
  #       format.xml  { head :ok }
  #       format.js   { render :partial => 'valorations' }
  #     else
  #       puts "XXX: #{@vote.errors.full_messages}"
  #       flash[:error] = "Error trying to update the vote: #{@vote.errors.full_messages}."        
  #       format.html { redirect_to( @paper ) }
  #       format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
end

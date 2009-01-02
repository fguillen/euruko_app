class CommentsController < ApplicationController

  before_filter :load_paper_by_paper_id
  
  # POST /comments
  # POST /comments.xml
  def create
    @comment = 
      Comment.new(
        :text   => params[:comment][:text],
        :paper  => @paper,
        :user   => current_user
      )
    
    respond_to do |format|
      if @comment.save
        logger.debug( "comentario guardado")
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to paper_path(@paper) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        logger.debug( "error en comentario: #{@comment.errors.full_messages}")
        flash[:error] = 'Error when try to save the Comment.'
        format.html { render :template => 'papers/show' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  

end

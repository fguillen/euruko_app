class CommentsController < ApplicationController
  before_filter :login_required
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
        format.html do 
          flash[:notice] = 'Comment was successfully created.'
          redirect_to paper_path(@paper)
        end
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js   { render :partial => 'papers/comment', :object => @comment }
      else
        logger.debug( "error en comentario: #{@comment.errors.full_messages}")
        format.html do 
          flash[:error] = 'Error when try to save the Comment.'
          render :template => 'papers/show'
        end
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        format.js   { render :partial => 'papers/comment_error', :object => @comment, :status => :unprocessable_entity }
      end
    end
  end
  

end

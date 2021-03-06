class CommentsController < ApplicationController

  before_filter :load_commentable
  before_filter :find_comment, :only => [:upvote, :downvote]
  before_action :authenticate_user!, :except => [:create]
  load_and_authorize_resource :except => [:create]
  skip_load_resource :only => [:create]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(params[:comment].permit!)
    if @post.author == @comment.author
      approve
    else
      redirect_to root_path
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to root_path
  end

  def upvote
    current_user.upvotes @comment
    redirect_to root_path
  end

  def downvote
    @comment.downvote_from current_user
    redirect_to root_path
  end

  def approve
    @comment.is_approved = true
    @comment.save
    redirect_to root_path
  end

  def reject
    @comment.destroy
    redirect_to root_path
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def find_comment
    @comment = Comment.find(@commentable.id)
  end

end

class CommentsController < ApplicationController

  before_filter :load_commentable
  before_filter :find_comment, :only => [:upvote, :downvote]
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(params[:comment].permit!)
    redirect_to root_path
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

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def find_comment
    @comment = Comment.find(@commentable.id)
  end

end

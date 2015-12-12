class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all.order(updated_at: :desc)
    @tags = Tag.joins(:posts).select('name').group('tags.name, tag_id').order('COUNT(tag_id)').reverse_order
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_url, notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_url, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    array_of_tags = @post.tags.joins(:posts).select('name, COUNT(posts_tags.tag_id) AS count')
      .group('tags.name, posts_tags.tag_id')
    array_of_tags.each do |tag|
      tag.destroy if tag.count <= 1
    end
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
    end
  end

  # FILTER
  def filter
    @posts = Post.all.joins(:tags).where(:tags => { :name => params[:name] }).order(updated_at: :desc)
    @tags = Tag.all.joins(:posts).select('name').group('tags.name, tag_id').order('COUNT(tag_id)').reverse_order
    respond_to do |format|
      format.html { render :index }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:author, :title, :body, :tags_string)
  end
end

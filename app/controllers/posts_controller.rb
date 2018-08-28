class PostsController < ApplicationController
  include PostsHelper
  before_action :authenticate_user!, except: [:index]
  before_action :get_post, only: [:show, :destroy]
  before_action :get_posts, only: [:index, :like, :dislike, :destroy, :create]

  def index
  end

  def new
    @post = Post.new
    @post_image = @post.post_images.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = params[:user_id]
    if @post.save
      if params[:post_images]
        params[:post_images]['avatar'].each do |avatar|
          @post_image = @post.post_images.create!(avatar: avatar)
        end
      end
      respond_to do |format|
        format.html { redirect_to @posts }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to :root_url }
        format.js
      end
    end
  end

  def like
    vote("like")
  end

  def dislike 
    vote("dislike")
  end
    
  def show
    @post_images = @post.post_images.all
  end

  def destroy
    if @post
      @post.destroy
      respond_to do |format|
        format.html { redirect_to @posts }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to :root_url }
        format.js
      end
    end
  end

  private

  def get_post
    @post = Post.find_by_id(params[:id])
  end
  
  def get_posts
    @posts = Post.
    select('posts.id as id, votes.votable_id, posts.name as name, sum(votes.vote_weight) as sum, posts.user_id, posts.created_at as created_at ').
    joins('left join votes on posts.id = votes.votable_id').
    group('posts.id, votes.votable_id').
    order('sum(votes.vote_weight) DESC NULLS LAST, posts.id ASC')
  end

  def post_params
    params.require(:post).permit(:name, :user_id, post_images_attributes: [:post_id, :avatar, :id])
  end
end

class PostsController < ApplicationController
  include PostsHelper
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:show, :destroy]
  respond_to :html, :js

  def index
    @posts = Post.select('posts.id as id, votes.votable_id, posts.name as name, sum(votes.vote_weight) as sum, posts.user_id, posts.created_at as created_at ').
    joins('left join votes on posts.id = votes.votable_id').group('posts.id, votes.votable_id').
    order('sum, created_at DESC') # need refactoring
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
      respond_with(@posts)
    else
      respond_with(@posts)
    end
  end

  def like
    vote("like")
  end

  def dislike 
    vote("dislike")
  end
    
  def show
    @post = Post.find(params[:id])
    @post_images = @post.post_images.all
  end

  def destroy
    if @post = Post.find(params[:id])
      @post.destroy
      @posts = Post.all
      respond_with(@posts)
    else
        redirect_to root_url
    end
  end

  private
  def set_post
    @post = Post.find_by_id(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:name, :user_id, post_images_attributes: [:post_id, :avatar, :id])
  end
end

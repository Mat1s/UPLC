class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  
  def index
    @comment = Comment.hash_tree
  end

  def create
    @post_image = PostImage.find(params[:post_image_id])
    @post = Post.find_by(id: @post_image.post_id)

  	if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))
      @comment = parent.children.build(comment_params)
    else
    	@comment = Comment.new(comment_params)
    end
    @comment.user_id = current_user.id
    @comment.post_image_id = params[:post_image_id]
    if @comment.save!
    	respond_to do |f|
        f.html { redirect_to @post }
        f.js { @comment }
      end
    else
    	respond_to do |f|
        f.html { render 'new' }
        f.js  
      end
    end
  end

  def new
    @comment = Comment.new(parent_id: params[:parent_id])
  end

  private
  def comment_params 
    params.require(:comment).permit(:body, :post_image_id, :user_id, comment: :body)
  end
end

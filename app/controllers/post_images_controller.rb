class PostImagesController < ApplicationController
	def edit 
		@post_image = PostImage.find(params[:id])
	end

	def update
		@post_image = PostImage.find(params[:id])
		if @post_image.update(post_images_params)
			@post = Post.find_by(id: @post_image.post_id)
			redirect_to @post
		else
			redirect_to root_url
		end
	end

	private
	def post_images_params
		params.require(:post_image).permit(:avatar, :post_id)
	end
end

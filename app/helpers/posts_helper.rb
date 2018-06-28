module PostsHelper
	def vote(type)
		 @post = Post.find(params[:id])
    if !current_user.voted_for?(@post)
      @post.vote_by :voter => current_user, :vote => "#{type}"
    else
      @post.unliked_by current_user
    end
      redirect_to root_url
  end

  def comments_tree_for(comments)
    comments.map do |comment, nested_comments|
      render(comment) +
          (nested_comments.size > 0 ? content_tag(:div, comments_tree_for(nested_comments), class: "replies") : nil)
    end.join.html_safe
  end
end

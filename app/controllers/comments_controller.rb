class CommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comments = @post.comments

    @comment = current_user.comments.build(comment_params)
    @comment.post = @post  # This is necessary to associate the newly created comment with its parent post.

    authorize @comment
    if @comment.save
      redirect_to [@topic, @post], notice: "Comment was saved successfully."
    else
      flash[:error] = "There was an error saving the comment.  Please try again."
      render 'posts/show'
    end
  end
  
  private 

  def comment_params
    params.require(:comment).permit(:body)
  end

end

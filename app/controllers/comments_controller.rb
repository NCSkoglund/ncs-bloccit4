class CommentsController < ApplicationController
  respond_to :html, :js

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comments = @post.comments

    @comment = current_user.comments.build(comment_params)
    @comment.post = @post  # This is necessary to associate the newly created comment with its parent post.
    @new_comment = Comment.new

    authorize @comment
    if @comment.save
      #flash[:notice] = "Comment was saved successfully."
    else
      #flash[:error] = "There was an error saving the comment.  Please try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    
    authorize @comment
    if @comment.destroy
      #flash[:notice] = "Hello world, the Comment was pwned."
    else
      flash[:error] = "Comment couldn't be deleted.  Please try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end
  
  private 

  def comment_params
    params.require(:comment).permit(:body)
  end

end

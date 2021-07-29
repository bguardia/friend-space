class CommentsController < ApplicationController
    def new
        @post = Post.find_by(id: params[:post_id])
        @comment = current_user.comments.build(post_id: params[:post_id])
    end

    def create
        @comment = current_user.comments.build(post_id: params[:post_id],
                                               body: comment_params[:body])
        if @comment.save
            flash[:notice] = "Successfully commented on post"
            redirect_to post_path(params[:post_id])
        else
            flash.now[:alert] = "There was a problem creating your comment"
            render 'new'
        end
    end

    def edit
        @comment = current_user.comments.find_by(id: params[:id])
        @post = Post.find(@comment.post_id)
    end

    def update
        @comment = current_user.comments.find_by(id: params[:id])
        if @comment.update(comment_params)
            flash[:notice] = "Successfully edited comment"
            redirect_to post_path(@comment.post_id)
        else
            flash[:alert] = "There was a problem editing your comment"
            redirect 'edit'
        end
    end

    def destroy
        @comment = current_user.comments.find_by(id: params[:id])
        @comment.destroy
        redirect_to post_path(@comment.post_id)
    end

    private
    def comment_params
        params.require(:comment).permit(:post_id, :body)
    end
end

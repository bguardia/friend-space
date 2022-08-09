class PostsController < ApplicationController

    def index
        @posts = Post.where(user_id: current_user.friends.ids).order(created_at: :desc)
        @post = Post.new
    end

    def show 
        @post = Post.find_by(id: params[:id])
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)

        if attachment_is_not_image
            flash[:alert] = "Attachment must be an image"
        elsif @post.save
            flash[:notice] = "Successfully created post"
            redirect_to @post 
            return
        else
            flash.now[:alert] = "Unable to create post"
        end

        redirect_back fallback_location: 'new'
    end

    def edit
        begin
            @post = current_user.posts.find_by!(id: params[:id])
        rescue
            if Post.find_by(id: params[:id])
                flash[:alert] = "You don't have permission to edit that post."
            else
                flash[:alert] = "Post does not exist."
            end
            redirect_to action: 'index'
        end
    end

    def update
        begin
            @post = current_user.posts.find_by!(id: params[:id])
        rescue 
            if Post.find_by(id: params[:id])
                flash[:alert] = "You don't have permission to edit that post."
            else
                flash[:alert] = "Post does not exist."
            end
            redirect_to action: 'index'
        end

        if attachment_is_not_image
            flash.now[:alert] = "Attachment must be an image"
        elsif @post.update(post_params)
            flash[:notice] = "Successfully updated post!"
            redirect_to @post
            return
        else
            flash.now[:alert] = "Unable to update post"
        end

        render 'edit'
    end

    def destroy
        begin
            @post = current_user.posts.find_by!(id: params[:id])
        rescue 
            if Post.find_by(id: params[:id])
                flash[:alert] = "You don't have permission to delete that post."
            else
                flash[:alert] = "Post does not exist."
            end
            redirect_to action: 'index'
        end

        @post.destroy
        flash[:notice] = "Post successfully deleted"
        redirect_to action: 'index'
    end

    private
    def post_params
        params.require(:post).permit(:body, :image)
    end

    private
    def attachment_is_not_image
        post_params[:image] && !post_params[:image].content_type.start_with?("image")
    end

end

class PostsController < ApplicationController
    def index
        @posts = Post.all
        @post = Post.new
    end

    def show 
        @post = Post.find_by(id: params[:id])
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)

        if @post.save
            flash[:notice] = "Successfully created post"
            redirect_to @post 
        else
            flash.now[:alert] = "Unable to create post"
            render 'new'
        end
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
            redirect_to 'index'
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
            redirect_to 'index'
        end

        if @post.update(post_params)
            flash[:notice] = "Successfully updated post!"
            redirect_to @post
        else
            flash.now[:alert] = "Unable to update post"
            render 'edit'
        end
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
            redirect_to 'index'
        end

        @post.destroy
    end

end

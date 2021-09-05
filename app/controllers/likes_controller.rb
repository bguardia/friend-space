class LikesController < ApplicationController

    def create
        like_type = params[:likeable_type]
        like_id = params[like_type.downcase.concat("_id").to_sym]
        begin
            @likeable = Object.const_get(like_type).find(like_id)
            @like = @likeable.likes.build(user_id: current_user.id)
            @like.save
            flash[:notice] = "Successfully liked post"
        rescue
            flash[:alert] = "Something wrent wrong liking that post."
        end

        redirect_back fallback_location: posts_url
    end

    def destroy
        @like = current_user.likes.find_by(id: params[:id])

        if @like
            @like.destroy
            flash[:notice] = "Successfully unliked post"
        else
            flash[:alert] = "Something went wrong unliking post"
        end

        redirect_back fallback_location: posts_url
    end

end

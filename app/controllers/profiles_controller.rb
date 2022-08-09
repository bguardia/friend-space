class ProfilesController < ApplicationController

    def edit
        @profile = current_user.profile
    end

    def update
        @profile = current_user.profile

        if avatar_is_not_image
            flash.now[:alert] = "Profile picture must be an image"
        elsif @profile.update(profile_params)
            flash[:notice] = "Successfully updated profile!"
            redirect_to user_path(current_user)
            return
        else
            flash.now[:alert] = "There was a problem updating your profile"
        end

        render 'edit'
    end

    private
    def profile_params
        params.require(:profile).permit(:firstname, :lastname, :bio, :birthday, :city, :country, :avatar)
    end

    private
    def avatar_is_not_image
        profile_params[:avatar] && !profile_params[:avatar].content_type.start_with?("image")
    end
end

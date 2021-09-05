class ProfilesController < ApplicationController

    def edit
        @profile = current_user.profile
    end

    def update
        @profile = current_user.profile
        if @profile.update(profile_params)
            flash[:notice] = "Successfully updated profile!"
            redirect_to user_path(current_user)
        else
            flash.now[:alert] = "There was a problem updating your profile"
            render 'edit'
        end
    end

    private
    def profile_params
        params.require(:profile).permit(:firstname, :lastname, :bio, :birthday, :city, :country, :avatar)
    end
end

class ProfilesController < ApplicationController
    skip_before_action :user_has_completed_profile, only: [:new, :create]

    def new
        @profile = current_user.build_profile
    end

    def create
        @profile = current_user.build_profile(profile_params)
        if @profile.save
            flash[:notice] = "Successfully set up your profile"
            redirect_to user_path(current_user)
        else
            flash.now[:alert] = "There was a problem setting up your profile"
            render 'new'
        end
    end

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

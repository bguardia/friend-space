class ApplicationController < ActionController::Base
    before_action :authenticate_user! 
    before_action :user_has_completed_profile

    private 
    def user_has_completed_profile
        if current_user
            redirect_to new_profile_path unless current_user.profile
        end
    end
end

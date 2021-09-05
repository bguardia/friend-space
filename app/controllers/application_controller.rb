class ApplicationController < ActionController::Base
    before_action :authenticate_user! 
    # helper :profile_picture_for

    def profile_picture_url_for(user, options)
        w = options.fetch(:width, nil) || options.fetch(:height, nil) || 64
        h = options.fetch(:height, nil) || w

        if user.profile.avatar.attached?
            url_for user.profile.avatar.variant(resize_to_fit: [w, h])
        else
            "https://via.placeholder.com/#{w}x#{h}"
        end
    end

    private 
    def user_has_completed_profile
        if current_user
            redirect_to new_profile_path unless current_user.profile
        end
    end


end

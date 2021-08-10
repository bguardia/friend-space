class UsersController < ApplicationController

    def index
        if params.key?(:username)
            name_query = "%#{params.fetch(:username, "")}%"
            @users = User.includes(:friend_requests, :friends)
                         .joins(profile: [:avatar_blob])
                         .where("CONCAT(profiles.firstname, ' ', profiles.lastname) ILIKE ?", name_query)
                         .all
        else
            @users = User.includes(:friend_requests, :friends, profile: [:avatar_blob]).all
        end
    end

    def show
        @user = User.find_by(id: params[:id])
    end

end

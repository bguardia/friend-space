class UsersController < ApplicationController

    def index
        @users = User.not_friends_with(current_user).not_pending_with(current_user).includes(:profile, :friend_requests).all
    end

    def show
        @user = User.find_by(id: params[:id])
    end
end

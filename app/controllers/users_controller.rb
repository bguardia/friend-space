class UsersController < ApplicationController

    def index
        @users = User.includes(:profile, :friend_requests).all
    end

    def show
        @user = User.find_by(id: params[:id])
    end
end

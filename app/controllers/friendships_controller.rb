class FriendshipsController < ApplicationController

    def index
        if params.key?(:username)
            name_query = "%#{params.fetch(:username, "")}%"
            @friends = User.includes(:friend_requests, :friends)
                         .joins(profile: [:avatar_blob])
                         .where(id: current_user.friends.ids)
                         .where("CONCAT(profiles.firstname, ' ', profiles.lastname) ILIKE ?", name_query)
                         .all
        else
            @friends = current_user.friends.all
        end
    end
end

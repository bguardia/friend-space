class FriendRequestsController < ApplicationController
    before_action :authenticate_user!

    def index
        @friend_requests = current_user.friend_requests.all
    end

    def create
        @friend_request = FriendRequest.new(sender_id: current_user, 
                                            receiver_id: params[:receiver_id],
                                            status: "Unanswered")
        if @friend_request.save
            flash[:notice] = "Successfully sent friend request"
        else
            flash.now[:alert] = "Something went wrong sending your request"
        end
    end

    def update
        @friend_request = FriendRequest.find_by(id: params[:id])
        if current_user.id == @friend_request.receiver_id
            @friend_request.status = friend_request_params[:status]
            if @friend_request.save
                flash[:notice] = "Successfully responded to friend request"
            else
                flash.now[:alert] = "Something went wrong responding to request"
            end
            redirect_back fallback_location: { action: 'index' }
        else
            flash.now[:alert] = "This request is for another user"
        end
    end

    private
    def friend_request_params
        params.require(:friend_request).permit(:status)
    end
end

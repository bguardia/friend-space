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
        begin
            @friend_request = current_user.friend_requests.find(params[:id])
            @friend_request.status = friend_request_params[:status]
            if @friend_request.save
                flash[:notice] = "Successfully responded to friend request"
                #Add friend if user accepted request
                current_user.friends << @friend_request.sender if @friend_request.status == "Accepted"
            else
                flash[:alert] = "Something went wrong responding to request"
            end
        rescue
            flash[:alert] = "Friend request not found"
        end
        
        redirect_back fallback_location: { action: 'index' }
    end

    private
    def friend_request_params
        params.require(:friend_request).permit(:status)
    end
end

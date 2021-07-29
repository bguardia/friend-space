class NotificationsController < ApplicationController
    def index
        @notifications = current_user.notifications.all
    end

    def update
        @notification = Notification.find_by(id: params[:id])
        @notification.update(status: params[:status])
        redirect_to action: 'index'
    end

end

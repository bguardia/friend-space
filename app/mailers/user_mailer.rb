class UserMailer < ApplicationMailer
    default from: "from@friendspace.com"

    def welcome_email
        @user = params[:user]
        @url = edit_profile_url
        mail(to: @user.email, subject: "Welcome to FriendSpace!")
    end
end

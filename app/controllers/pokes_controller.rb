class PokesController < ApplicationController
    before_action :authenticate_user!

    def create
        if current_user.friends.exists?(params[:poke][:receiver_id])
            @poke = Poke.new(sender_id: current_user.id,
                            receiver_id: params[:poke][:receiver_id])
            
            if @poke.save
                poked_user = User.find(params[:poke][:receiver_id])
                flash[:notice] = "Successfully poked #{poked_user.profile.firstname + " " + poked_user.profile.lastname}"
            else
                flash[:alert] = "Something went wrong with your poke. Please try again."
            end
        else
            flash[:alert] = "You can only poke your friends."
        end
        
        redirect_back fallback_location: posts_url
    end
end

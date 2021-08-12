class PrivacyPolicyController < ApplicationController
    skip_before_action :authenticate_user!, :user_has_completed_profile

    def show
    end
end

module ProfilesHelper
    def profile_picture_url(user, dimension_array = [64, 64])
        @avatar = user.profile.avatar.attached? && user.profile.avatar.image? ? user.profile.avatar : nil
        @avatar ? url_for(@avatar.variant(resize_to_fill: dimension_array)) : "https://via.placeholder.com/#{dimension_array[0]}x#{dimension_array[1]}"
    end
end

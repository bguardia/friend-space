module PostSeeder

    POST_DATA_DIR = "post_data"
    POST_DATA_BASE = "post_json"
    POST_DATA_PATH = POST_DATA_DIR + "/" + POST_DATA_BASE
    POST_PHOTO_PATH = POST_DATA_DIR + "/photos"


    def self.seed
        image_posts = [{body: "Los Angeles is so beautiful!", image: "henning-witzel-ukvgqriuOgo-unsplash.jpg"},
                       {body: "My favorite photo from my vacation last week! I can't wait to go back someday.", image: "ibrahim-rifath-NJ7CaVfWYaw-unsplash.jpg"},
                    {image: "luca-bravo-VowIFDxogG4-unsplash.jpg"},
                    {image: "kalen-emsley-_LuLiJc1cdo-unsplash.jpg"},
                    {image: "nikola-majksner-hXNGeAFOgT4-unsplash.jpg"},
                    {image: "dave-hoefler-lsoogGC_5dg-unsplash.jpg"}]
        

        text_only_posts = [{body: "Wow! What a day! I was so busy. I can't wait to unwind while spending some time on FriendSpace."},
                           {body: "Who wants to meet up for a drink this afternoon?"},
                           {body: "Ugh, who invented waking up before 9:00 in the morning?"},
                           {body: "Hi everyone!"},
                           {body: "We're throwing a birthday party for John tomorrow. Everyone is welcome!"}]
        
        posts = image_posts.concat(text_only_posts)

        users = User.limit(posts.length)

        users.each_with_index do |user, num|
            image_file = posts[num].delete(:image)
            post_data = posts[num]
            post = user.posts.build(posts[num])
            if image_file
                post.image.attach(io: File.open(POST_PHOTO_PATH + "/" + image_file),
                                  filename: image_file,
                                  content_type: "image/jpeg")
            end
            post.save
        end
    end

end
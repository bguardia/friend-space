require "open-uri"

module UserSeeder
#Locations for storing data previously retrieved
    USER_DATA_DIR = "user_data"
    PROFILE_PICS_DIR = USER_DATA_DIR + "/" + "photos"
    USER_DATA_BASE = "user_json"
    USER_DATA_PATH = USER_DATA_DIR + "/" + USER_DATA_BASE

    def self.retrieve_user_data
        data = ""
        File.open(USER_DATA_PATH, "r") do |f|
            f.each_line { |l| data += l }
        end
        data
    rescue SystemCallError => e
        puts "#{e.class.name}: #{USER_DATA_PATH} not found."
        nil
    end

    def self.request_user_data
        puts "Calling RandomUser API for user data..."
        user_json_data = ""
        URI.open("https://randomuser.me/api/?results=50&inc=gender,name,email,location,dob,picture") do |f|
            f.each_line do |l|
                user_json_data += l
            end
        end

        @@requested_data = JSON.parse(user_json_data)["results"]
    end

    def self.request_user_photos(data)
        puts "Downloading user photos..."
        count = 0
        data.each do |user_hash|
            photo_path = "#{PROFILE_PICS_DIR}/user-#{count}.jpg"
            system("curl -o \"#{photo_path}\" #{user_hash[:profile][:picture]}", exception: true)
            user_hash[:profile][:picture] = photo_path
            count += 1
        end
    end

    def self.organize_user_data(data)
        puts "Reorganizing user data..."
        @@organized_data = data.map do |user_hash|
            {   email: user_hash["email"], 
                password: "1234567890",
                password_confirmation: "1234567890",
                profile: { firstname: user_hash["name"]["first"],
                            lastname: user_hash["name"]["last"],
                            birthday: user_hash["dob"], 
                            city: user_hash["location"]["city"], 
                            country: user_hash["location"]["country"], 
                            picture: user_hash["picture"]["large"] } 
            }
        end
    end

    def self.create_dir(dir_str)
        system("mkdir #{dir_str}") unless File.directory?(dir_str)
    end

    def self.serialize_user_data(data)
        self.create_dir(USER_DATA_DIR)
        self.create_dir(PROFILE_PICS_DIR)
        self.request_user_photos(data)
        
        puts "Saving user data to #{USER_DATA_PATH}"
        File.open(USER_DATA_PATH, "w") do |f|
            f.write JSON.dump(data)
        end
    rescue => e
        puts "#{e.class.name} occured while trying to save user information."
        puts "Deleting any saved records..."
        system("rm -Rv #{USER_DATA_DIR}") if File.directory?(USER_DATA_DIR)
    end


    def self.seed
        unless File.exist?(USER_DATA_PATH) && File.directory?(PROFILE_PICS_DIR)
            self.request_user_data
            self.organize_user_data(@@requested_data)
            self.serialize_user_data(@@organized_data)
        end

        #Only attempt to store in DB if directories exist
        if File.exist?(USER_DATA_PATH) && File.directory?(PROFILE_PICS_DIR)
            puts "Getting user data..."
            @@organized_data ||= JSON.parse self.retrieve_user_data

            puts "Storing users in database..."
            begin 
                @@organized_data.each do |user_hash|
                    profile_hash = user_hash.delete(:profile)
                    pic_file_path = profile_hash.delete(:picture)
                    u = User.create(user_hash)
                    u.create_profile(profile_hash)
                    u.profile.avatar.attach(io: File.open(pic_file_path), 
                                            filename: pic_file_path[/[[:alnum:]]*.jpg/], 
                                            content_type: 'image/jpg')
                end
            rescue => e
                puts "An error occured while trying to save a user to the database: \n#{e.class.name}: #{e.message}"
                puts "Deleting any saved users..."
                User.destroy_all
            end

            puts "#{User.count} users successfully stored in database."
        end
    end

end

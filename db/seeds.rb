# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require "user_seeds"

=begin
days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

user_names = ["Yuvaan Palmer",
    "Amos Cortez",
    "Seren Hodges",
    "Percy Rowley",
    "Asiyah Dickerson",
    "Annika Odonnell",
    "Yasir Beech",
    "Mya Caldwell",
    "Nakita Redfern",
    "Abiha Nairn",
    "Keon Sandoval",
    "Kayla Tate",
    "Blanche Juarez",
    "Vivien Calvert",
    "Armani Mcfarlane",
    "Daphne Walter",
    "Kristie Sharples",
    "Samia White",
    "Amarah O'Brien",
    "Ruairidh Beach"]

prng = Random.new

puts "Building user data..."
users_data = user_names.map do |name|
    first, last = name.split(" ")
    year = Time.now.year - prng.rand(100)
    month = prng.rand(12)
    day = prng.rand(days_in_month[month])

    { profile: { firstname: first,
                 lastname: last,
                 birthday: Date.new(year, month + 1, day + 1) },

      user: { email: "#{first}-#{last}@jmail.com".downcase,
              password: "1234567890",
              password_confirmation: "1234567890"
            }
     }
end

puts "Creating users..."
users_data.each do |data|
    u = User.create(data[:user])
end
puts "#{User.all.count} users successfully created."

# Creating profiles in above block throws a "parent not saved" error
puts "Adding user profiles..."
users_data.each do |data|
    u = User.find_by(email: data[:user][:email])
    u.create_profile(data[:profile]) unless u.nil?
end
puts "#{Profile.all.count} profiles successfully created."
=end 

UserSeeder.seed



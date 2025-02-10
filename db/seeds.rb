# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# create list of users
User.create(name: "Alice")
User.create(name: "Bob")
User.create(name: "Charlie")
User.create(name: "David")
User.create(name: "Eve")

# create list of follows
Follow.create(follower: User.find_by(name: "Alice"), followee: User.find_by(name: "Bob"))
Follow.create(follower: User.find_by(name: "Alice"), followee: User.find_by(name: "Charlie"))
Follow.create(follower: User.find_by(name: "Bob"), followee: User.find_by(name: "Charlie"))
Follow.create(follower: User.find_by(name: "Charlie"), followee: User.find_by(name: "David"))
Follow.create(follower: User.find_by(name: "David"), followee: User.find_by(name: "Eve"))
Follow.create(follower: User.find_by(name: "Eve"), followee: User.find_by(name: "Alice"))

# create list of sleeps clock in and out
Sleep.create(user: User.find_by(name: "Alice"), clock_in: Time.now - 6.hours, clock_out: Time.now)
Sleep.create(user: User.find_by(name: "Bob"), clock_in: Time.now - 7.hours, clock_out: Time.now)
Sleep.create(user: User.find_by(name: "Charlie"), clock_in: Time.now - 8.hours, clock_out: Time.now)
Sleep.create(user: User.find_by(name: "David"), clock_in: Time.now - 9.hours, clock_out: Time.now)
Sleep.create(user: User.find_by(name: "Eve"), clock_in: Time.now - 10.hours, clock_out: Time.now)

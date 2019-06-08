# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Sample users
names = %w[sample jane pat carla mike bob nick]
names.each do |name|
  e_mail = name + '@example.com'
  User.create(email: e_mail, password: 'samplepass', password_confirmation: 'samplepass')
end

# Ratings
Movie.all.each do |movie|
  User.all.each do |user|
    num_stars = rand(1..5)
    Rating.create(movie_id: movie.id, user_id: user.id, stars: num_stars)
  end
end

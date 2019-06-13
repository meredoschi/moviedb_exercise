# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

names = %w[sample jane pat carla mike bob nick]
names.each do |name|
  e_mail = name + '@example.com'
  User.create!(email: e_mail, password: 'samplepass', password_confirmation: 'samplepass')
end

movie_genres = ['Action', 'Adventure', 'Animation', 'Comedy', 'Documentary', 'Drama',
                'Musical', 'Mystery', 'Science Fiction', 'Thriller', 'Western']
movie_genres.each do |genre|
  Category.create!(name: genre)
end

user_ids = User.all.pluck(:id)

category_ids = Category.pluck(:id)

(1..35).each do |_n|
  artist_name = Faker::Artist.unique.name
  verb1 = Faker::Verb.unique.past_participle.capitalize
  verb2 = Faker::Verb.unique.past_participle

  Movie.create!(title: artist_name, summary: verb1 + ' sample text ' + verb2,
                category_id: category_ids.sample, user_id: user_ids.sample)
end

Movie.all.each do |movie|
  User.where.not(email: 'sample@example.com').each do |user|
    num_stars = rand(1..5)
    Rating.create!(movie_id: movie.id, user_id: user.id, stars: num_stars)
  end
end

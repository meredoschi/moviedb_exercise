# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Sample users

names = %w[sample carla jane mike nick pat bob wanda]
names.each do |name|
  e_mail = name + '@example.com'
  User.create!(email: e_mail, password: 'samplepass', password_confirmation: 'samplepass')
end

# Create movie genres (categories)
movie_genres = ['Action', 'Adventure', 'Animation', 'Comedy', 'Documentary', 'Drama',
                'Musical', 'Mystery', 'Science Fiction', 'Thriller', 'Western']
movie_genres.each do |genre|
  Category.create!(name: genre)
end

# Create movies
user_ids = User.all.pluck(:id)

category_ids = Category.pluck(:id)

(1..35).each do |_n|
  artist_name = Faker::Artist.unique.name
  verb1 = Faker::Verb.unique.past_participle.capitalize
  verb2 = Faker::Verb.unique.past_participle
  txt = %w[text script plot narrative story]
  words = %w[about all and artistic cinematic journey many sequel series]
  Movie.create!(title: artist_name, summary: [verb1, txt.sample, verb2, words.sample].join(' '),
                category_id: category_ids.sample, user_id: user_ids.sample)
end

# Rate movies
Movie.all.each_with_index do |movie, indx|
  num_stars = if indx < 5
                indx + 1
              else
                rand(1..5)
              end
  User.where.not(email: 'sample@example.com').each_with_index do |user, _indx|
    Rating.create!(movie_id: movie.id, user_id: user.id, stars: num_stars)
  end
end

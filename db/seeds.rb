# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'sample@example.com', password: 'samplepass',
             password_confirmation: 'samplepass')
movie_genres = ['Action', 'Adventure', 'Animation', 'Comedy', 'Documentary', 'Drama',
                'Musical', 'Mystery', 'Science Fiction', 'Thriller', 'Western']
movie_genres.each do |genre|
  Category.create(name: genre)
end

user_ids = User.pluck(:id)

movie_list = []
movie_list << { title: 'The sample',
                summary: 'The sample wons an award for...', category_id: 1 }
movie_list << { title: 'Winter tale',
                summary: 'On this movie, the main characters...', category_id: 2 }
movie_list << { title: 'Planet XYZ',
                summary: 'In a recently discovered planet...', category_id: 3 }
movie_list << { title: 'A real documentary',
                summary: 'Things are very real in this documentary about...', category_id: 4 }
movie_list << { title: 'Sleepwalking in Antarctica',
                summary: 'The new release from the famous director...', category_id: 1 }
movie_list << { title: 'The Zombies',
                summary: 'As the name implies, there are many zombies...', category_id: 7 }
movie_list << { title: 'The basketball players',
                summary: 'Based on the classic novel by...', category_id: 2 }
movie_list << { title: 'The ball game',
                summary: 'An american baseball story...', category_id: 5 }
movie_list << { title: 'The sequel',
                summary: 'It continues where the previous movie left off...', category_id: 3 }
movie_list << { title: 'The saga',
                summary: 'All 17 episodes, restored in full digital colors..', category_id: 6 }
movie_list << { title: 'Provisional',
                summary: 'A working title which remained...', category_id: 6 }
movie_list << { title: 'The temperature',
                summary: 'Tells the tale of a climatologist', category_id: 3 }

movie_list.each do |movie|
  title = movie[:title]
  summary = movie[:summary]
  category_id = movie[:category_id]

  Movie.create!(title: title, summary: summary, category_id: category_id, user_id: user_ids.sample)
end

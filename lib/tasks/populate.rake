# frozen_string_literal: true

require 'faker'

namespace :populate do
     desc 'Create sample category and movie records'
     task all: %i[categories movies]

  task categories: :environment do
    num_records_created = 0

    names_raw = [] # may include duplicates, unsorted

    # https://github.com/stympy/faker/pull/752
    (1..Settings.number_of_sample_records).each do |n|
      category = Category.create(name: Faker::Company.unique.industry)
      num_records_created += 1 if category
    end

    puts 'Categories created: ' + num_records_created.to_s
  end

  desc 'Create some movies'

  task movies: :environment do
    num_records_created = 0

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
                    summary: 'As the name implies, there are many zombies...', category_id: 5 }
    movie_list << { title: 'The basketball players',
                    summary: 'Based on the classic novel by...', category_id: 2 }
    movie_list << { title: 'The ball game',
                    summary: 'An american baseball story...', category_id: 5 }
    movie_list << { title: 'The sequel',
                    summary: 'It continues where the previous movie left off...', category_id: 3 }
    movie_list << { title: 'The saga',
                    summary: 'All 17 episodes, restored in full digital colors..', category_id: 5 }
    movie_list << { title: 'Provisional',
                    summary: 'A working title which remained...', category_id: 5 }
    movie_list << { title: 'The temperature',
                            summary: 'Tells the tale of a climatologist', category_id: 3 }

    movie_list.each do |movie|
      title = movie[:title]
      summary = movie[:summary]
      category_id = movie[:category_id]

      new_movie_created = Movie.create(title: title, summary: summary, category_id: category_id)
      num_records_created += 1 if new_movie_created
    end

    puts 'Movies created: ' + num_records_created.to_s
  end
end

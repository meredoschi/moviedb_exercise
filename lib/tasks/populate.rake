# frozen_string_literal: true

require 'faker'

namespace :populate do
  #  desc 'Populate all'
  #  task all: %i[categories]

  desc 'Create many category records with sample data'

  task categories: :environment do
    num_records_created = 0

    names_raw = [] # may include duplicates, unsorted

    (1..Settings.number_of_sample_records).each do |_n|
      names_raw << Faker::Company.industry
    end

    names = names_raw.sort.uniq

    names.each do |sample_name|
      category = Category.create(name: sample_name)
      num_records_created += 1 if category
    end

    puts 'New records created: ' + num_records_created.to_s
  end
end

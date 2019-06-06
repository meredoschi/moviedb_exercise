# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { FactoryBot.create(:movie) }
  let(:category) { FactoryBot.create(:category) }

  # Associations

  it { is_expected.to belong_to(:category) }

  # Validations

  # Class methods

  # Adapted from https://stackoverflow.com/questions/53169565/how-to-add-item-to-json-object-ruby-on-rails
  it '#detailed_info' do
    movie_list = []
    movies = Movie.all
    movies.each do |movie|
      movie_info = movie.attributes
      movie_info[:category_name] = movie.category_name
      movie_list << movie_info
    end
    expect(movie_list).to eq(Movie.detailed_info)
  end

  # Instance methods
  it 'can be created' do
    FactoryBot.create(:movie)
  end

  it 'five can be created' do
    FactoryBot.create_list(:movie, 5)
  end

  it '-category_name' do
    movie_category_name = movie.category.name
    expect(movie_category_name).to eq(movie.category_name)
  end
end

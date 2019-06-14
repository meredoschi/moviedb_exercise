# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { FactoryBot.create(:movie) }
  let(:category) { FactoryBot.create(:category) }

  # Associations

  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:user) }

  # Validations

  # Class methods

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

  it '-num_ratings' do
    movie_num_ratings = movie.ratings.count
    expect(movie_num_ratings).to eq movie.num_ratings
  end

  it '-stars_total' do
    movie_stars_total = movie.ratings.sum(:stars)
    expect(movie_stars_total).to eq movie.stars_total
  end

  # average rating
  it '-stars' do
    movie_stars = movie.stars_total / movie.num_ratings
    expect(movie_stars).to eq movie.stars
  end
end

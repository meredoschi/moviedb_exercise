# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    num_stars = Random.rand(6)
    association :movie, factory: :movie
    association :user, factory: :user
    stars { num_stars }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    num_stars = Random.rand(6)
#    association :user, factory: :user
    association :movie, factory: :movie
    stars { num_stars }
  end
end

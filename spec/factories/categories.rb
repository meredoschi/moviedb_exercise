# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| ((n + 100_000).to_s + Faker::Company.unique.industry).to_s }
  end
end

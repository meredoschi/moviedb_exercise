# frozen_string_literal: true

# User
FactoryBot.define do
  factory :user do
    sample_pass = 'sample-pass'
    sequence(:email) { |n| ('Sample' + (n + 1000).to_s + Faker::Internet.email).to_s }
    password { sample_pass }
    password_confirmation { sample_pass }
    #    confirmed_at { Date.today }
  end
end

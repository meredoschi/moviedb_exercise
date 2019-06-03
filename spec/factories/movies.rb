# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    sample_name = Faker::Name.unique.prefix + ' ' + Faker::Name.unique.last_name
    verb = Faker::Verb.unique.past_participle
    sequence(:title) { |n| (sample_name + ' ' + verb + ' ' + n.to_s + Faker::Internet.email).to_s }

    #    title { sample_name+' '+verb }
    summary { 'Movie information...' }
    association :category, factory: :category
  end
end

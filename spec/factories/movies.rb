# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    sample_name = Faker::Name.prefix + ' ' + Faker::Name.last_name
    verb = Faker::Verb.unique.past_participle
    sequence(:title) do |n|
      (sample_name + ' ' + verb + ' ' + \
      n.to_s + Faker::Internet.email).to_s
    end

    #    title { sample_name+' '+verb }
    summary { 'Movie information...' }
    association :category, factory: :category
    association :user, factory: :user
  end
end

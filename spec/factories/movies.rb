# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    sample_name = Faker::Name.prefix + ' ' + Faker::Name.last_name
    verb = Faker::Verb.unique.past_participle
    present_tense = Faker::Verb.unique.simple_present

    sequence(:title) do |n|
      (sample_name + ' ' + verb + ' ' + \
      n.to_s + Faker::Internet.email).to_s
    end

    #    title { sample_name+' '+verb }
    summary { present_tense }
    association :category, factory: :category
    association :user, factory: :user
  end
end

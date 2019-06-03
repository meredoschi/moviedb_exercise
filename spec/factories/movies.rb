# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    title { 'MyString' }
    summary { 'MyText' }
    category_id { 1 }
  end
end

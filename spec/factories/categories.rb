FactoryBot.define do
  factory :category do
    sample_name=Faker::Company.industry
    name { sample_name }
  end
end

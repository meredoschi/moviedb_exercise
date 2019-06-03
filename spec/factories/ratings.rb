FactoryBot.define do
  factory :rating do
    user_id { 1 }
    movie_id { 1 }
    stars { 1 }
  end
end

FactoryBot.define do
  factory :gallery do
    title { "MyString" }
    description { "MyText" }
    user { nil }
    status { 1 }
    views_count { 1 }
    likes_count { 1 }
    photos_count { 1 }
  end
end

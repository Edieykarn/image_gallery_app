FactoryBot.define do
  factory :photo do
    title { "MyString" }
    description { "MyText" }
    gallery { nil }
    likes_count { 1 }
  end
end

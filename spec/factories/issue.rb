FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph(2) }
    user { association :user }
  end
end

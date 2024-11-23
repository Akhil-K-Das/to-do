FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" } # Ensures unique email addresses
    password { "password" }
  end
end
FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2024-11-23 14:35:41" }
  end
end

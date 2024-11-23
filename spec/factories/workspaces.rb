FactoryBot.define do
  factory :workspace do
    name { "Example Workspace" }
    url { "example.com" }
    api_key { "sample_api_key" }
  end
end
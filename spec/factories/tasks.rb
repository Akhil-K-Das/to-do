FactoryBot.define do
  factory :task do
    title { "Default Task" }
    due_date { Time.zone.now + 1.day }
    association :category
    association :workspace
    association :assignee_id, factory: :user # Assignee is linked to the User model
  end
end
FactoryGirl.define do
  factory :star do
    association :starring_user, factory: :user
    association :starred_snippet, factory: :snippet
  end
end

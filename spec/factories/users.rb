FactoryGirl.define do
  factory :user do
    name     'Tarō Yamada'
    sequence(:email) { |n| "tyamada#{n}@example.com" }
    password 'passw0rd'

    factory :user_with_comments do
      transient do
        comments_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:comment, evaluator.comments_count, comment_author: user)
      end
    end
  end
end

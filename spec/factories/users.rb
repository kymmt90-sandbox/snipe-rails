FactoryGirl.define do
  factory :user do
    name     'Tarō Yamada'
    sequence(:email) { |n| "tyamada#{n}@example.com" }
    password 'passw0rd'

    factory :user_with_comments do
      transient do
        comments_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:comment, evaluator.comments_count, comment_author: user)
      end
    end

    factory :user_with_starred_snippets do
      transient do
        starred_snippets_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:snippet, evaluator.starred_snippets_count).each do |snippet|
          user.starred_snippets << snippet
        end
      end
    end
  end
end

FactoryGirl.define do
  factory :snippet do
    sequence(:title) { |n| "Snippet #{n}" }
    content 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    association :author, factory: :user

    factory :snippet_with_comments do
      transient do
        comments_count 5
      end

      after(:create) do |snippet, evaluator|
        create_list(:comment, evaluator.comments_count, snippet: snippet)
      end
    end

    factory :snippet_with_starring_users do
      transient do
        starring_users_count 5
      end

      after(:create) do |snippet, evaluator|
        users = create_list(:user, evaluator.starring_users_count)
        users.each { |user| snippet.starring_users << user }
      end
    end
  end
end

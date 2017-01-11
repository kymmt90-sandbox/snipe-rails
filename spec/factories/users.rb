FactoryGirl.define do
  factory :user do
    name     'Tarō Yamada'
    sequence(:email) { |n| "tyamada#{n}@example.com" }
    password 'passw0rd'
  end
end

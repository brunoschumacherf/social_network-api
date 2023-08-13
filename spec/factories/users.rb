FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { "#{Random.rand(1000)}test2@example" }
    password { '@Aa12345' }
    password_confirmation { '@Aa12345' }
  end
  factory :user2, class: User do
    name { 'Jane Doe' }
    email { "#{Random.rand(1000)}test2@example" }
    password { '@Aa12345' }
    password_confirmation { '@Aa12345' }
  end
end

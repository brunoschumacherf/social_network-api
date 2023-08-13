FactoryBot.define do
  factory :publication do
    title { 'Title' }
    description { 'Description of the publication' }
    # Associar a publicação a um usuário
    association :user, factory: :user
  end
end

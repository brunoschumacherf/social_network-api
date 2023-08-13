FactoryBot.define do
  factory :comment do
    comment { 'Description of the comment' }
    association :commentable, factory: :publication  # Associa o comentário a uma publicação
    # Associar o comentário a um usuário
    association :user, factory: :user
  end
end

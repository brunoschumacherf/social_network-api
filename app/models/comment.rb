class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :replies, class_name: 'Comment', as: :commentable

  def full_map
    {
      id: id,
      comment: comment,
      archive: Tempfile.new(archive).path,
    }
  end
end

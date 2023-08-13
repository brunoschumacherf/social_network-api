class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, dependent: :destroy
  has_many :replies, class_name: 'Comment', as: :commentable, dependent: :destroy

  def full_map
    data = {
      id: id,
      comment: comment,
      replies: replies.map(&:full_map),
      user: user.full_map
    }
    data[:arquive] = archive if archive
    data
  end

  def self.map_comments(comments)
    comments.map(&:full_map)
  end
end

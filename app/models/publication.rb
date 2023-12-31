class Publication < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :comments, as: :commentable

  def map_create
    data = {
      id: id,
      title: title,
      description: description
    }
    data[:archive] = archive if archive
    data
  end

  def full_map
    data = {
      id: id,
      title: title,
      description: description,
    }
    data[:archive] = archive if archive
    data[:user] = user.full_map
    data[:comments] = Comment.map_comments(comments)
    data
  end

  def self.map_publications(publications)
    publications.map(&:full_map)
  end
end

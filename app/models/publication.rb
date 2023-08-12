class Publication < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable

  def full_map
    {
      id: id,
      title: title,
      description: description,
      archive: Tempfile.new(archive).path,
      user: user.full_map
    }
  end

  def self.map_publications(publications)
    publications.map(&:full_map)
  end
end

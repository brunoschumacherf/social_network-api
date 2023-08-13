class PublicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :files, :user, :comments
  has_many :comments
end

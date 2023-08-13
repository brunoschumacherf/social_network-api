class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :user
  def user
    object.user.full_map
  end
end

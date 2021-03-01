class PostCommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :user, :created_at, :comment_user_image

  # 投稿者の画像のURLを返す
  def comment_user_image
    object.user.image_url
  end
end

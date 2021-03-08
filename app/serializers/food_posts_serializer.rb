class FoodPostsSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :user_id, :user, :created_at, :image, :post_user_image

  # 画像のURLを返す
  def image
    object.image_url
  end

  # 投稿者の画像のURLを返す
  def post_user_image
    object.user.image_url
  end
end

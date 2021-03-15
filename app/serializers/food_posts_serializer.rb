class FoodPostsSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :user_id, :created_at, :image, :post_user_image
  belongs_to :user, serializer: UserSerializer

  # 画像のURLを返す
  def image
    if object.image_url
      object.image_url
    else
      nil
    end
  end

  # 投稿者の画像のURLを返す
  def post_user_image
    if object.user.image_url
      object.user.image_url
    else
      nil
    end
  end
end

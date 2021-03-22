class FoodPostsSerializer < ActiveModel::Serializer
  attributes :id, :food_code, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :user_id, :created_at, :image, :post_user_image, :func
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

  # コントローラから値を受け取る
  def func
    if instance_options[:func]
      func =  instance_options[:func]
    end
  end
end

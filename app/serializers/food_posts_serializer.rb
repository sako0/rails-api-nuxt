class FoodPostsSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :food_code, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :user_id, :created_at, :post_user_id, :func
  belongs_to :user, serializer: UserSerializer

  # 画像のURLを返す
  def image
    if object.image_url
      object.image_url
    else
      nil
    end
  end

  def post_id
    object.id
  end

  # 投稿者のidを返す
  def post_user_id
    object.user.id
  end

  # コントローラから値を受け取る
  def func
    if instance_options[:func]
      func = instance_options[:func]
    end
  end
end

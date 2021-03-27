class FoodEatSerializer < ActiveModel::Serializer
  attributes :id, :eat_id, :user_id, :product_name, :food_code, :par, :calorie, :protein, :lipid, :carbohydrate, :percent, :date, :created_at, :post_id, :post_user_id

  def eat_id
    object.id
  end

  def post_user_id
    if object.post_id
      if FoodPost.find(object.post_id)
        FoodPost.find(object.post_id).user_id
      end
    end
  end

end
class FoodEatSerializer < ActiveModel::Serializer
  attributes :id, :eat_id, :user_id, :product_name, :food_code, :par, :calorie, :protein, :lipid, :carbohydrate, :percent, :date, :created_at

  def eat_id
    object.id
  end

end
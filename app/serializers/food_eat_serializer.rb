class FoodEatSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :product_name, :food_code, :par, :calorie, :protein, :lipid, :carbohydrate, :percent, :date
end
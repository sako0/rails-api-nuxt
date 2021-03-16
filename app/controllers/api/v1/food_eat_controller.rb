class Api::V1::FoodEatController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def create
    logger.error(params)
    if params[:food_eat].present?
      food_eat = @current_user.food_eats.build(food_eat_params)
      food_eat.user_id = @current_user.id
      if food_eat.save
        render json: "投稿に成功しました"
      end
    end
  end

  def food_eat_params
    params.require(:food_eat).permit(:id, :food_code, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :percent)
  end
end

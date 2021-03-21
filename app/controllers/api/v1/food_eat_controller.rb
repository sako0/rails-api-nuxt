class Api::V1::FoodEatController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  before_action :destroy_id_get, only: [:destroy]

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

  def update
    if params[:food_eat].present?
      foodEat = @current_user.food_eats.find_by(id: params[:food_eat][:id])
      foodEat.updated_at = Time.now
      if foodEat.update(food_eat_params)
        render json: "更新に成功しました"
      else
        render json: "更新に失敗しました"
      end
    end
  end

  def destroy
    if @food_eat.destroy
      render json: "削除完了しました"
    else
      render json: "削除に失敗しました"
    end
  end

  def show
    date = Date.strptime(params[:id], "%Y-%m-%d")
    food_eat_at_day = FoodEat.where("date >= ?", date)
    render json: food_eat_at_day, each_serializer: FoodEatSerializer
  end

  def guideline
    age = @current_user.profiles.age
    sex = @current_user.profiles.sex
    height = @current_user.profiles.height
    target_weight = @current_user.profiles.target_weight
    action_level = @current_user.profiles.action_level
    @recommended_calorie = 0
    @recommended_protein = 0
    @recommended_lipid = 0
    @recommended_carbohydrate = 0
    bee = 0

    # カロリー計算
    if age < 2
      if sex
        @recommended_calorie = 660
      else
        @recommended_calorie = 700
      end
    elsif age > 2 && age < 6
      if sex
        @recommended_calorie = 840
      else
        @recommended_calorie = 900
      end
    elsif age > 5 && age < 8
      if sex
        @recommended_calorie = 920
      else
        @recommended_calorie = 980
      end
    elsif age > 7 && age < 10
      if sex
        @recommended_calorie = 1050
      else
        @recommended_calorie = 1140
      end
    elsif age > 9 && age < 12
      if sex
        @recommended_calorie = 1260
      else
        @recommended_calorie = 1330
      end
    elsif age > 11 && age < 15
      if sex
        @recommended_calorie = 1410
      else
        @recommended_calorie = 1520
      end
    elsif age > 14 && age < 18
      if sex
        @recommended_calorie = 1310
      else
        @recommended_calorie = 1610
      end
    else
      if sex
        bee = (0.0481 * target_weight + 0.0234 * height - 0.0138 * age - 0.9708) * 1000 / 4.186
        @recommended_calorie = bee * action_level
      else
        bee = (0.0481 * target_weight + 0.0234 * height - 0.0138 * age - 0.4235) * 1000 / 4.186
        @recommended_calorie = bee * action_level
      end
    end
    if age < 1
      @recommended_protein = 20
      @recommended_lipid = 40
      @recommended_carbohydrate = 0
    else
      @recommended_protein = @recommended_calorie * 0.15 / 4
      @recommended_lipid = @recommended_calorie * 0.25 / 9
      @recommended_carbohydrate = @recommended_calorie * 0.6 / 4
    end
    @recommended_calorie = @recommended_calorie.floor
    @recommended_protein = @recommended_protein.floor
    @recommended_lipid = @recommended_lipid.floor
    @recommended_carbohydrate = @recommended_carbohydrate.floor
    json = { recommended_calorie: @recommended_calorie, recommended_protein: @recommended_protein, recommended_lipid: @recommended_lipid, recommended_carbohydrate: @recommended_carbohydrate }.to_json
    render json: json
  end

  private

  def food_eat_params
    params.require(:food_eat).permit(:id, :food_code, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :date, :percent)
  end

  def destroy_id_get
    @food_eat = @current_user.food_eats.find_by(id: params[:id])
    if @food_eat.nil?
      render json: "投稿が存在しません"
    end
  end

end

class Api::V1::FoodPostsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  before_action :destroy_id_get, only: [:destroy]

  def index
    # 参考
    # https://qiita.com/eggc/items/29a3c9a41d77227fb10a
    @food_posts = @current_user.food_posts.all
    render json: @food_posts, each_serializer: FoodPostsSerializer
  end

  def create
    logger.error(params)
    if params[:food_posts].present?
      @food_posts = @current_user.food_posts.build(food_posts_params)
      @food_posts.image.attach(params[:image]) if params[:image]
      search_food_code = FoodPost.find_by(food_code: @food_posts.food_code)
      if search_food_code
        search_food_code.updated_at = Time.now
        search_food_code.update(food_posts_params)
        render json: "更新に成功しました"
      else
        if @food_posts.save
          render json: "投稿に成功しました"
        else
          if @food_posts.errors.any?
            render json: @food_posts.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
          else
            render json: "不明なエラー"
          end
        end
      end
    end
  end

  def destroy
    if @food_posts.destroy
      ActionCable.server.broadcast("micropost_channel", { method: "destroy", post_user_id: @current_user.id, micropost_id: @micropost.id })
      render json: "削除完了しました"
    else
      render json: "削除に失敗しました"
    end
  end

  private

  def food_posts_params
    params.require(:food_posts).permit(:id, :food_code, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate, :image)
  end

  def destroy_id_get
    @food_posts = @current_user.food_posts.find_by(id: params[:id])
    if @food_posts.nil?
      render json: "投稿が存在しません"
    end
  end
end
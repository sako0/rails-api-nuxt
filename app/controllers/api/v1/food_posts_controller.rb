class Api::V1::FoodPostsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  before_action :destroy_id_get, only: [:destroy]

  def index
    # 参考
    # https://qiita.com/eggc/items/29a3c9a41d77227fb10a
    @food_posts = @current_user.food_posts.where(food_code: nil)
    render json: @food_posts, each_serializer: FoodPostsSerializer, include: [:user]
  end

  def create
    logger.error(params)
    if params[:food_post].present?
      if params[:food_post][:food_code].present?
        # 対象バーコードに対して自分の投稿したfood_postがある場合、POSTの新規作成ではなく更新を行う
        if @current_user.food_posts.exists?(food_code: params[:food_post][:food_code])
          search_food_code = @current_user.food_posts.find_by(food_code: params[:food_post][:food_code])
          search_food_code.updated_at = Time.now
          search_food_code.update(food_posts_params)
          render json: search_food_code.id
        else
          # バーコードに対する、自分のfood_postが1件もない場合、POSTの新規作成を行う
          food_post = @current_user.food_posts.create(food_posts_params)
          if food_post
            render json: food_post.id
          else
            if @food_posts.errors.any?
              render json: @food_posts.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
            else
              render json: "不明なエラー"
            end
          end
        end
      else
        # food_codeがない場合は下記
        # paramsにidがある場合
        if params[:food_post][:id]
          # paramのidが自分のpostであれば、updateを行う
          logger.error('idがある！')
          if @current_user.food_posts.exists?(params[:food_post][:id])
            search_food_post = @current_user.food_posts.find(params[:food_post][:id])
            search_food_post.updated_at = Time.now
            search_food_post.update(food_posts_params)
            render json: search_food_post.id
          else
            logger.error('postが見つからなかった')
            # 削除等により、idに紐づくpostが存在しない場合は新規で作成する
            food_post = @current_user.food_posts.create(food_posts_params)
            if food_post
              render json: food_post.id
            else
              if food_post.errors.any?
                render json: food_post.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
              else
                render json: "不明なエラー"
              end
            end
          end
        else
          # paramsにidがない場合はpostの新規作成を行う
          food_post = @current_user.food_posts.create(food_posts_params)
          if food_post
            render json: food_post.id
          else
            if food_post.errors.any?
              render json: food_post.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
            else
              render json: "不明なエラー"
            end
          end
        end
      end

    end
  end

  def destroy
    if @food_posts.destroy
      render json: "削除完了しました"
    else
      render json: "削除に失敗しました"
    end
  end

  private

  def food_posts_params
    params.require(:food_post).permit(:id, :food_code, :product_name, :par, :calorie, :protein, :lipid, :carbohydrate)
  end

  def destroy_id_get
    @food_posts = @current_user.food_posts.find_by(id: params[:id])
    if @food_posts.nil?
      render json: "投稿が存在しません"
    end
  end
end
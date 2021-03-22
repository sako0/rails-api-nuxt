class Api::V1::FoodsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  require 'mechanize'

  def show
    if @current_user.food_posts.find_by(food_code: params[:id])
      code = @current_user.food_posts.find_by(food_code: params[:id])
      render json: code, serializer: FoodPostsSerializer, include: [:user], func: "my"
    elsif @current_user.food_post_useds.find_by(food_code: params[:id])
      used = @current_user.food_post_useds.find_by(food_code: params[:id])
      code = used.food_post
      render json: code, serializer: FoodPostsSerializer, include: [:user], func: "used"
    elsif FoodPost.find_by(food_code: params[:id])
      list = FoodPost.where(food_code: params[:id])
      render json: list, each_serializer: FoodPostsSerializer, func: "list"
    else
      web_search(params[:id])
    end
  end

  def create
    logger.error(params)
    if params[:food][:func] == "web" || params[:food][:func] == "my"
      @food_post_useds_params = @current_user.food_post_useds.build(food_post_useds_params)
      @food_post_useds_params.target_user_id = @current_user.id
      search_food_code = FoodPostUsed.find_by(food_code: @food_post_useds_params.food_code)
      if search_food_code
        search_food_code.updated_at = Time.now
        search_food_code.update(food_post_useds_params)
        render json: "更新に成功しました"
      else
        if @food_post_useds_params.save
          render json: "投稿に成功しました"
        else
          if @food_post_useds_params.errors.any?
            render json: @food_post_useds_params.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
          else
            render json: "不明なエラー"
          end
        end
      end
    end
  end

  # バーコードの数字を送るとweb上から取得した栄養素情報を返す(例：/api/v1/web_search?id=4987035332510)
  def web_search(code)
    food_code = code
    search_url = "https://www.eatsmart.jp/do/caloriecheck/list1?category=02&searchKey=" + food_code
    agent = Mechanize.new
    agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_2_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.72 Safari/537.36"
    page = agent.get(search_url)
    doc = Nokogiri::HTML.parse(page.body)
    content = doc.at("a[href*='/do/caloriecheck/detail/param/foodCode']")
    if content.present?
      page = agent.get("https://www.eatsmart.jp" + content["href"])
      doc = Nokogiri::HTML.parse(page.body)
      name = doc.search("h3.itemName")
      par = doc.search("div.itemSubInfo")
      capas = doc.search("td.capa")
      calorie = capas[0].text.gsub('kcal', '').to_f
      protein = capas[1].text.gsub('g', '').to_f
      lipid = capas[2].text.gsub('g', '').to_f
      carbohydrate = capas[3].text.gsub('g', '').to_f
      json = { web_search: true, food_code: code, content: true, product_name: name[0].text, par: par[0].text, calorie: calorie, protein: protein, lipid: lipid, carbohydrate: carbohydrate }.to_json
    else
      json = { web_search: true, food_code: code, content: false }
    end
    render json: json
  end

  private

  def food_post_useds_params
    params.require(:food).permit(:id, :user_id, :food_code, :food_post_id, :target_user_id)
  end
end
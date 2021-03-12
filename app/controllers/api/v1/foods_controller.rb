class Api::V1::FoodsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  require 'mechanize'

  def show
    if @current_user.food_posts.find_by(food_code: params[:id])
      code = @current_user.food_posts.find_by(food_code: params[:id])
      render json: code.to_json
      # elsif FoodPost.find(FoodPostUsed.group(params[:id]).order('count(id) desc').limit(1).pluck(:food_post_id))
      #   code = FoodPost.find(FoodPostUsed.group(params[:id]).order('count(id) desc').limit(1).pluck(:food_post_id))
      #   render json: code.to_json
    else
      web_search(params[:id])
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
      json = { product_name: name[0].text, par: par[0].text, calorie: calorie, protein: protein, lipid: lipid, carbohydrate: carbohydrate }.to_json
    else
      json = "no content"
    end
    render json: json
  end
end
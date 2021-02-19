class Api::V1::SessionsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate, except: :create

  def create
    logger.error(params)
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      # jwtの発行
      jwt_token = encode(user.id.to_s)
      logger.error(jwt_token)
      # レスポンスヘッダーにトークンを設定
      response.headers['Authorization'] = jwt_token
      logger.error(response.headers['Authorization'])
      render json: jwt_token
    end
  end

  def index
    render json: @current_user
  end
end

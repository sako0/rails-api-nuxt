class Api::V1::SessionsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate, except: :create

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      # jwtの発行
      jwt_token = encode(user.id.to_s)
      # レスポンスヘッダーにトークンを設定
      response.headers['Authorization'] = jwt_token
      render json: jwt_token
    end
  end

  def index
    image = @current_user.display_image ? url_for(@current_user.display_image) : nil
    background_image = @current_user.display_background_image ? url_for(@current_user.display_background_image) : nil
    render json: { user:
                     { id: @current_user.id,
                       name: @current_user.name,
                       email: @current_user.email,
                       profile: @current_user.profiles,
                       image: image,
                       background_image: background_image,
                     }
    }
  end
end

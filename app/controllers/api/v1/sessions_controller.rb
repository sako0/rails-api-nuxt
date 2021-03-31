class Api::V1::SessionsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate, except: :create

  def create
    if params[:token]
      twitter_user = firebase_decode(params[:token])
      user = User.find_by(twitter_id: twitter_user['user_id'])
      jwt_token = nil
      if user
        logger.error(user)
        jwt_token = encode(user.id.to_s)
      else
        user = User.create!(name: twitter_user['name'],
                           twitter_id: twitter_user['user_id'])
        user.image_attach_by_url(twitter_user['picture'])
        user.build_profiles(age: 20, sex: false, height: 170, target_weight: 65, action_level: 1.5, notes: "プロフィールを修正して下さい")
        user.save
        jwt_token = encode(user.id.to_s)
      end
      # レスポンスヘッダーにトークンを設定
      if jwt_token
        response.headers['Authorization'] = jwt_token
        render json: jwt_token
      else
        render false
      end
    else
      user = User.find_by(email: params[:email].downcase)
      if user && user.authenticate(params[:password])
        # jwtの発行
        jwt_token = encode(user.id.to_s)
        # レスポンスヘッダーにトークンを設定
        response.headers['Authorization'] = jwt_token
        render json: jwt_token
      end
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

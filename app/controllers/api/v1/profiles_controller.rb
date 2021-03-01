class Api::V1::ProfilesController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def create
    # プロフィールイメージのプレビュー用画像のurlを返す
    if params[:image]
      profiles_image_url = @current_user.preview_image(params[:image])
      render json: profiles_image_url, status: :ok
    end
    # プロフィール背景のプレビュー用画像のurlを返す
    if params[:background]
      profiles_background_url = @current_user.preview_background_image(params[:background])
      render json: profiles_background_url, status: :ok
    end
  end
end

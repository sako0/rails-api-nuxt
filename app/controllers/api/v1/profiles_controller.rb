class Api::V1::ProfilesController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def create
    logger.error(params)
    profiles_image_url = @current_user.preview_image(params[:image])
    render json: profiles_image_url, status: :ok
  end
end

class Api::V1::UsersController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def update
    logger.error(params)
    user = @current_user
    if params[:user][:image]
      user.image.attach(params[:user][:image])
      user.display_image.processed
    end
    if params[:user][:background]
      user.back_ground.attach(params[:user][:background])
      user.display_background_image.processed
    end
    if user.update(user_params)
      render json: { status: "success" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 profiles_attributes: [:id, :trend, :notes, :url])
  end
end

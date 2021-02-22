class Api::V1::UsersController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def update
    logger.error(params)
    user = @current_user
    user.image.attach(params[:user][:image]).processed if params[:user][:image]
    user.back_ground.attach(params[:user][:background]).processed if params[:user][:background]
    if user.update(user_params)
      render json: { status: "success" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 profiles_attributes: [:id, :location, :skills, :notes, :url, :job])
  end
end

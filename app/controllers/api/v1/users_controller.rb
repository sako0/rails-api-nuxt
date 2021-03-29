class Api::V1::UsersController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def update
    logger.error(params)
    user = @current_user
    preview_image_destroy(user)
    if params[:user][:image]
      if user.image.attached?
        user.image.purge
      end
      user.image.attach(params[:user][:image])
      user.display_image.processed
    end
    if params[:user][:background]
      if user.back_ground.attached?
        user.back_ground.purge
      end
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
                                 profiles_attributes: [:age, :sex, :height, :target_weight, :action_level, :notes])
  end

  def preview_image_destroy(user)
    if user.image_preview.attached?
      user.image_preview.purge
    end
    if user.back_ground_preview.attached?
      user.back_ground_preview.purge
    end
  end
end

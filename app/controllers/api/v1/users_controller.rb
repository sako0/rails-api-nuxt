class Api::V1::UsersController < ApplicationController
  # before_action :authenticate_api_user!

  def show
    user = User.find_by(id: params[:id])
    render json: {
      user: {
        id: user.id,
        name: user.name,
        email: user.email
      }
    }
  end
end

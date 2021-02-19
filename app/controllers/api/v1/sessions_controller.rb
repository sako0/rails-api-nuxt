class Api::V1::SessionsController < ApplicationController

  def create
    logger.error(params)
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      base = SecureRandom.urlsafe_base64.downcase
      render json: base
    end
  end

  def index

  end
end

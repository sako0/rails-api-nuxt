class Api::V1::SessionsController < ApplicationController
  def create
    logger.error(params)
    user = User.find_by(email: params[:session][:email].downcase)
    token = User.new_token
    token_json=`{
      "token": #{token}
    }`
    render json: token_json
  end
  def destroy

  end
end

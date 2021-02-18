class Api::V1::SessionsController < ApplicationController
  #before_action :authenticate_api_user!
  def index
    render json: current_user.all.as_json
  end
end

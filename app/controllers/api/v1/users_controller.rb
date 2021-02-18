class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_user!

  def index
    render json: "aaa"
  end
end

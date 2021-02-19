class Api::V1::MicropostsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def index
    # 参考
    # https://qiita.com/eggc/items/29a3c9a41d77227fb10a
    logger.error(@current_user.id)
    # @micropost = Micropost.find_by(user_id: @current_user.id)
    @micropost = @current_user.micropost.all
    render json: @micropost, each_serializer: MicropostSerializer
  end
end
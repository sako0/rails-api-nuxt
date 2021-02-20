class Api::V1::MicropostsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def index
    # 参考
    # https://qiita.com/eggc/items/29a3c9a41d77227fb10a
    @micropost = @current_user.micropost.all
    render json: @micropost, each_serializer: MicropostSerializer
  end

  def create
    logger.error(params)
    if params[:micropost][:content].present?
      @micropost = @current_user.micropost.build(micropost_params)
      @micropost.image.attach(params[:image]) if params[:image]
      if @micropost.save
        ActionCable.server.broadcast("micropost_channel", { method: "create", post_user_id: @current_user.id, user_id: @current_user.id })
        render json: "success"
      else
        if @micropost.errors.any?
          render json: @micropost.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
        else
          render json: "不明なエラー"
        end
      end
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:id, :content, :image,
                                      post_comments_attributes: [:id, :content, :image])
  end
end
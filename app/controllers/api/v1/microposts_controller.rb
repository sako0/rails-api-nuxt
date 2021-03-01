class Api::V1::MicropostsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  before_action :destroy_id_get, only: [:destroy]

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
        # 自分だけに表示させる処理
        ActionCable.server.broadcast("micropost_channel", { method: "create", post_user_id: @current_user.id, user_id: @current_user.id })
        render json: "投稿に成功しました"
      else
        if @micropost.errors.any?
          render json: @micropost.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").to_json
        else
          render json: "不明なエラー"
        end
      end
    end
  end

  def destroy
    if @micropost.destroy
      ActionCable.server.broadcast("micropost_channel", { method: "destroy", post_user_id: @current_user.id, micropost_id: @micropost.id })
      render json: "削除完了しました"
    else
      render json: "削除に失敗しました"
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:id, :content, :image,
                                      post_comments_attributes: [:id, :content, :image])
  end

  def destroy_id_get
    @micropost = @current_user.micropost.find_by(id: params[:id])
    if @micropost.nil?
      render json: "投稿が存在しません"
    end
  end
end
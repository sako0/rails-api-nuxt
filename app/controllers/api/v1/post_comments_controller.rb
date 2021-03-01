class Api::V1::PostCommentsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate
  before_action :destroy_id_get, only: [:destroy]

  def create
    user = @current_user
    post_comment = PostComment.new(post_comment_params)
    post_comment.user_id = user.id
    if post_comment.save
      ActionCable.server.broadcast("post_comments_channel", { method: "create", micropost_id: post_comment.micropost.id.to_s })
      render json: "投稿に成功しました", status: :ok
    end
  end

  def index
    post_comment_index = PostComment.where(micropost_id: params[:micropost_id])
    render json: post_comment_index, each_serializer: PostCommentSerializer
  end

  def destroy
    destroyed_post_comment = @post_comment
    if @post_comment.destroy
      ActionCable.server.broadcast("post_comments_channel", { method: "destroy", micropost_id: destroyed_post_comment.micropost.id.to_s })
      render json: '削除完了しました'
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:content, :micropost_id)
  end

  def destroy_id_get
    destroy_post_comment = PostComment.find_by(id: params[:id])
    if destroy_post_comment
      if destroy_post_comment.user_id == @current_user.id
        @post_comment = destroy_post_comment
        return
      else
        render json: "投稿者のみが削除できます"
      end
      render json: "投稿が存在しません"
    end
  end
end

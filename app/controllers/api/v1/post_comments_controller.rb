class Api::V1::PostCommentsController < ApplicationController
  include JwtAuthenticator
  before_action :jwt_authenticate

  def create
    user = @current_user
    post_comment = PostComment.new(post_comment_params)
    post_comment.user_id = user.id
    if post_comment.save
      render json: "投稿に成功しました", status: :ok
    end
  end

  def index
    post_comment_index = PostComment.where(micropost_id: params[:micropost_id])
    render json: post_comment_index, each_serializer: PostCommentSerializer
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:content, :micropost_id)
  end
end

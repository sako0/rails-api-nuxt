class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :created_at, :image, :post_user_image

  # 画像のURLを返す
  def image
    object.image_url
  end

  # 画像のURLを返す
  def post_user_image
    object.user.image_url
    # routes = Rails.application.routes.url_helpers
    # url = routes.url_for(object.user.display_image.processed)
  end
end

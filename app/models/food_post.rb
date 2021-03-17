class FoodPost < ApplicationRecord
  belongs_to :user
  has_many :food_post_useds, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :product_name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :par, presence: true, length: { minimum: 1, maximum: 70 }
  validates :calorie, presence: true, length: { minimum: 1, maximum: 70 }
  validates :protein, presence: true, length: { minimum: 1, maximum: 70 }
  validates :lipid, presence: true, length: { minimum: 1, maximum: 70 }
  validates :carbohydrate, presence: true, length: { minimum: 1, maximum: 70 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  include Rails.application.routes.url_helpers
  # アタッチされている画像を圧縮する
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  # 投稿者のイメージ画像をURLで返す
  def post_user_image
    self.user.image_url
  end

  # 画像のURLを返す
  def image_url
    if self.image.attached?
      # url_forは基本modelでは使えないが以下を参考に実施した
      # https://qiita.com/ogawatti/items/f60f757cdb6a67256885
      routes = Rails.application.routes.url_helpers
      routes.url_for(self.display_image.processed)
    end
  end
end

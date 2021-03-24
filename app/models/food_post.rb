class FoodPost < ApplicationRecord
  belongs_to :user
  has_many :food_post_useds, foreign_key: "food_post_id", dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :product_name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :par, presence: true, length: { minimum: 1, maximum: 70 }
  validates :calorie, presence: true, length: { minimum: 1, maximum: 70 }
  validates :protein, presence: true, length: { minimum: 1, maximum: 70 }
  validates :lipid, presence: true, length: { minimum: 1, maximum: 70 }
  validates :carbohydrate, presence: true, length: { minimum: 1, maximum: 70 }

  # 投稿者のイメージ画像をURLで返す
  def post_user_image
    self.user.image_url
  end
end

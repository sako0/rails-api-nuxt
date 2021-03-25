class User < ApplicationRecord
  has_many :food_posts, dependent: :destroy
  has_many :food_eats, dependent: :destroy
  has_one :profiles, dependent: :destroy, class_name: "Profile"
  accepts_nested_attributes_for :profiles
  has_many :food_post_useds, class_name: 'FoodPostUsed', foreign_key: "user_id", dependent: :destroy
  has_many :food_post_used_target, class_name: 'FoodPostUsed', foreign_key: "target_user_id"
  # 画像のアタッチ
  has_one_attached :image
  has_one_attached :back_ground
  has_one_attached :image_preview
  has_one_attached :back_ground_preview
  validates(:name, presence: true, length: { maximum: 50 })
  validates(:email, presence: true, length: { maximum: 255 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true)
  has_secure_password
  validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)
  attr_accessor :remember_token, :activation_token, :reset_token
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  validates :back_ground, content_type: { in: %w[image/jpeg image/gif image/png],
                                          message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  validates :image_preview, content_type: { in: %w[image/jpeg image/gif image/png],
                                            message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  validates :back_ground_preview, content_type: { in: %w[image/jpeg image/gif image/png],
                                                  message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  include Rails.application.routes.url_helpers

  # ユーザプロフィールイメージを圧縮する
  def display_image
    self.image.variant(gravity: :center, resize: "640x640^", crop: "640x640+0+0") if self.image.attached?
  end

  # ユーザプロフィールイメージを圧縮する
  def display_background_image
    self.back_ground.variant(gravity: :center, resize: "2400x1600^", crop: "2400x1920+0+0") if self.back_ground.attached?
  end

  # プレビューイメージを圧縮したURLを返す
  def preview_image(image)
    self.image_preview.attach(image)
    routes = Rails.application.routes.url_helpers
    image = image_preview.variant(gravity: :center, resize: "640x640^", crop: "640x640+0+0")
    routes.url_for(image.processed)
  end

  # プレビューイメージを圧縮したURLを返す
  def preview_background_image(image)
    self.back_ground_preview.attach(image)
    routes = Rails.application.routes.url_helpers
    image = back_ground_preview.variant(gravity: :center, resize: "2400x1600^", crop: "2400x1920+0+0")
    routes.url_for(image.processed)
  end

  # 画像のURLを返す
  def image_url
    if self.image.attached?
      # url_forは基本modelでは使えないが以下を参考に実施した
      # https://qiita.com/ogawatti/items/f60f757cdb6a67256885
      routes = Rails.application.routes.url_helpers
      routes.url_for(self.display_image.processed)
    else
      nil
    end
  end

  # def default_image
  #   if !self.image.attached?
  #     url = URI.parse("http://free-photo.net/photo_img/0812105448.jpg")
  #     filename = File.basename(url.path)
  #     image = URI.open(url)
  #     self.image.attach(io: image, filename: filename)
  #   end
  # end
  #
  # def default_back_ground_image
  #   if !self.back_ground.attached?
  #     url = URI.parse("https://publicdomainq.net/images/201710/07s/publicdomainq-0014143ddc.jpg")
  #     filename = File.basename(url.path)
  #     image = URI.open(url)
  #     self.back_ground.attach(io: image, filename: filename)
  #   end
  # end
end

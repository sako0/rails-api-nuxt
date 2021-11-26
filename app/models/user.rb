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
  # ユーザ作成前の画像アタッチ
  before_create :default_image, :default_back_ground_image
  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, allow_nil: true)
  has_secure_password(validations: false)
  validates(:email, length: { maximum: 255 }, allow_nil: true)
  validates(:password, length: { minimum: 6 }, allow_nil: true)
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
    if self.image_preview.attached?
      self.image_preview.purge
    end
    self.image_preview.attach(image)
    routes = Rails.application.routes.url_helpers
    image = image_preview.variant(gravity: :center, resize: "640x640^", crop: "640x640+0+0")
    routes.url_for(image.processed)
  end

  # プレビューイメージを圧縮したURLを返す
  def preview_background_image(image)
    if self.back_ground_preview.attached?
      self.back_ground_preview.purge
    end
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

  # 画像のURLからユーザのイメージをアタッチする
  def image_attach_by_url(url)
    uri = URI.parse(url)
    filename = File.basename(uri.path)
    image = URI.open(uri)
    self.image.attach(io: image, filename: filename)
  end

  # 初期イメージのアタッチ
  def default_image
    unless self.image.attached?
      image_attach_by_url("https://www.pakutaso.com/shared/img/thumb/KAZ19514004_TP_V.jpg")
    end
  end

  # 初期背景イメージのアタッチ
  def default_back_ground_image
    unless self.back_ground.attached?
      url = URI.parse("https://www.pakutaso.com/shared/img/thumb/N845_mokumetex_TP_V.jpg")
      filename = File.basename(url.path)
      image = URI.open(url)
      self.back_ground.attach(io: image, filename: filename)
    end
  end
end

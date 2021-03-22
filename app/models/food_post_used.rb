class FoodPostUsed < ApplicationRecord
  belongs_to :user
  belongs_to :target_user, class_name: "User", optional: true, foreign_key: "target_user_id"
  belongs_to :food_post, optional: true
  validates :user_id, presence: true
  validates :target_user_id, presence: true
  validates :food_post_id, presence: true
end

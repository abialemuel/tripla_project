class User < ApplicationRecord
  has_many :sleeps, dependent: :destroy
  has_many :follower_relationships, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followee
end

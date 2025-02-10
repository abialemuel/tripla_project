class User < ApplicationRecord
  has_many :sleeps, dependent: :destroy
  has_many :follower_relationships, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followee

  def following?(user)
    following_relationships.exists?(followee_id: user.id)
  end

  # Prevents duplicate follows (Concurrency-safe)
  def follow(user)
    following_relationships.find_or_create_by(followee_id: user.id)
  end

  # Prevents race conditions when unfollowing
  def unfollow(user)
    following_relationships.destroy_by(followee_id: user.id)
  end
end

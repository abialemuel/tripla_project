class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", counter_cache: :following_count
  belongs_to :followee, class_name: "User", counter_cache: :follower_count

  validates :follower_id, uniqueness: { scope: :followee_id }
end

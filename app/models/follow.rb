class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", counter_cache: :following_count
  belongs_to :followee, class_name: "User", counter_cache: :followers_count
end

class UserSerializer < BaseSerializer
  attributes :name, :follower_count, :following_count, :created_at, :updated_at
end

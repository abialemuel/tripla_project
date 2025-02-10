require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:follower).class_name('User').counter_cache(:following_count) }
    it { is_expected.to belong_to(:followee).class_name('User').counter_cache(:follower_count) }
  end

  describe "validations" do
    it "validates uniqueness of follow relationship" do
      user1 = User.create!(name: "User 1")
      user2 = User.create!(name: "User 2")
      Follow.create!(follower: user1, followee: user2)

      duplicate_follow = Follow.new(follower: user1, followee: user2)
      expect(duplicate_follow).not_to be_valid
    end
  end

  describe "counter_cache" do
    let!(:user1) { User.create!(name: "User 1", following_count: 0) }
    let!(:user2) { User.create!(name: "User 2", follower_count: 0) }

    it "updates the follower and following counts correctly" do
      expect { Follow.create!(follower: user1, followee: user2) }
        .to change { user1.reload.following_count }.by(1)
        .and change { user2.reload.follower_count }.by(1)
    end
  end
end

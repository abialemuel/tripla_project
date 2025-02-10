require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:sleeps).dependent(:destroy) }
    it { should have_many(:follower_relationships).class_name('Follow').with_foreign_key('followee_id').dependent(:destroy) }
    it { should have_many(:followers).through(:follower_relationships).source(:follower) }
    it { should have_many(:following_relationships).class_name('Follow').with_foreign_key('follower_id').dependent(:destroy) }
    it { should have_many(:following).through(:following_relationships).source(:followee) }
  end

  describe "methods" do
    let(:user) { User.create(name: "User A") }
    let(:another_user) { User.create(name: "User B") }

    describe "#following?" do
      it "returns true if the user is following another user" do
        user.follow(another_user)
        expect(user.following?(another_user)).to be true
      end

      it "returns false if the user is not following another user" do
        expect(user.following?(another_user)).to be false
      end
    end

    describe "#follow" do
      it "follows another user" do
        expect { user.follow(another_user) }.to change { user.following.count }.by(1)
      end

      it "does not create duplicate follow relationships" do
        user.follow(another_user)
        expect { user.follow(another_user) }.not_to change { user.following.count }
      end
    end

    describe "#unfollow" do
      it "unfollows another user" do
        user.follow(another_user)
        expect { user.unfollow(another_user) }.to change { user.following.count }.by(-1)
      end

      it "does nothing if the user is not following the other user" do
        expect { user.unfollow(another_user) }.not_to change { user.following.count }
      end
    end
  end
end

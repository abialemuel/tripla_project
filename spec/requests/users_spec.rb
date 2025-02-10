require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let!(:user) { User.create(name: "Test User") }
  let!(:other_user) { User.create(name: "Other User") }
  let(:token) { JWT.encode({ user_id: user.id }, ENV["JWT_SECRET"], "HS256") } # If using JWT authentication
  let!(:auth_headers) { { "Authorization" => "Bearer #{token}" } }  # Mock authentication

  describe "GET /users" do
    it "returns a list of users" do
      get "/users"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(User.count)
    end
  end

  describe "GET /users/:id" do
    it "returns user details" do
      get "/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq(user.name)
    end
  end

  describe "POST /users/:id/follow" do
    context "when not already following" do
      it "follows the user" do
        post "/users/#{other_user.id}/follow", headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("You are now following #{other_user.name}")
      end
    end

    context "when already following" do
      before { user.follow(other_user) }

      it "returns an error" do
        post "/users/#{other_user.id}/follow", headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Already following this user")
      end
    end
  end

  describe "DELETE /users/:id/unfollow" do
    before { user.follow(other_user) }

    it "unfollows the user" do
      delete "/users/#{other_user.id}/unfollow", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("You have unfollowed #{other_user.name}")
    end
  end

  describe "GET /users/following_sleep_records" do
    let!(:sleep_record) { Sleep.create(user: other_user, clock_in: 2.days.ago, clock_out: 1.day.ago) }

    before { user.follow(other_user) }

    it "returns sleep records of followed users" do
      get "/users/following_sleep_records", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST /users/clock_in" do
    it "creates a new sleep record" do
      post "/users/clock_in", headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["clock_in"]).not_to be_nil
    end
  end

  describe "POST /users/clock_out" do
    let!(:sleep_record) { user.sleeps.create(clock_in: 2.hours.ago) }

    it "clocks out the user" do
      post "/users/clock_out", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["clock_out"]).not_to be_nil
    end
  end

  describe "GET /users/clocked_in_times" do
    let!(:sleep_records) { create_list(:sleep, 3, user: user) }

    it "returns all sleep records" do
      get "/users/clocked_in_times"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Sleep.count)
    end
  end
end

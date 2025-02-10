require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  let(:user) { create(:user, name: "testuser") }
  let(:valid_headers) { { "Authorization" => "Bearer #{JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, ENV["JWT_SECRET"], "HS256")}" } }

  describe "POST /login" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post "/auth/login", params: { name: user.name }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["data"]["token"]).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post "/auth/login", params: { name: "wrongname" }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["error"]["message"]).to eq("Invalid credentials")
      end
    end
  end

  describe "GET /me" do
    context "when authenticated" do
      it "returns the current user" do
        get "/auth/me", headers: valid_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq(user.name)
      end
    end

    context "when unauthorized" do
      it "returns 401 Unauthorized" do
        get "/auth/me"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login ]

  def login
    user = User.find_by(name: params[:name]) # Replace with real authentication logic

    if user
      token = generate_jwt(user.id)
      render json: { data: { token: token } }
    else
      render json: { error: { message: "Invalid credentials" } }, status: :unauthorized
    end
  end

  def me
    render json: current_user, serializer: UserSerializer
  end

  private

  def generate_jwt(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base || ENV["JWT_SECRET"], "HS256")
  end
end

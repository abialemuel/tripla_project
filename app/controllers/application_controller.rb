class ApplicationController < ActionController::API
  before_action :authenticate_request

  def authenticate_request
    @current_user = authenticate_token
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  private

  def authenticate_token
    token = request.headers["Authorization"]&.split(" ")&.last
    return nil unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base || ENV["JWT_SECRET"], true, algorithm: "HS256")
      user_id = decoded_token[0]["user_id"]
      User.find_by(id: user_id)
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    @current_user
  end
end

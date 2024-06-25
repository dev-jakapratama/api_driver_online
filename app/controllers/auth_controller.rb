class AuthController < ApplicationController
  # POST /login
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      check_refresh_token = RefreshToken.find_by_user_id(user.id)
      refresh_token  = check_refresh_token if check_refresh_token.present?
      refresh_token =  RefreshToken.create(token: SecureRandom.hex, expires_at: 7.days.from_now) if check_refresh_token.nil?
      render json: { jwt_token: token, refresh_token: refresh_token.token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end

  end

  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, Rails.application.credentials.jwt_secret)
  end

  def refresh
    refresh_token = RefreshToken.find_by(token: params[:refresh_token])
    if refresh_token && refresh_token.expires_at > Time.now
      user = refresh_token.user
      token = encode_token({ user_id: user.id })
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
    end
  end
  

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.jwt_secret)
  end    
end

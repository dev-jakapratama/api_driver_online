class AuthController < ApplicationController
  # POST /login
  def login
    user = User.find_by(email: params[:email])
  
    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      refresh_token = user.refresh_tokens.create(token: SecureRandom.hex, expires_at: 7.days.from_now)
      render json: { token: token, refresh_token: refresh_token.token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end

  end

  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
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
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end    
end

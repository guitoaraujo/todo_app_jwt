class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize

  SECRET = 'secret_word'.freeze
  ALGORITHM = 'HS256'.freeze

  def encode_token(payload)
    JWT.encode(payload, SECRET)
  end

  def decode_token
    auth_token = request.headers['Authorization']

    return unless auth_token

    token = auth_token.split(' ').last

    return if BlacklistedToken.find_by(token: token).present?

    JWT.decode(token, SECRET, true, algorith: ALGORITHM)
  end

  def authorized_user
    decoded_token = decode_token

    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def authorize
    render json: { errors: 'You must login!' }, status: :unauthorized unless authorized_user
  end
end

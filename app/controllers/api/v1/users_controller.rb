class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :authorize

  EXPIRATION_TIME = 8.hours.from_now.to_i

  def create
    @user = User.create(user_params)

    if @user.valid?
      render json: { user: @user, token: create_token }, status: :ok
    else
      render json: { errors: @user.errors.messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: user_params[:username])

    if @user && @user&.authenticate(user_params[:password])
      render json: { user: @user, token: create_token }, status: :ok
    else
      render json: { errors: 'Invalid credentials!' }, status: :unprocessable_entity
    end
  end

  def logout
    auth_token = request.headers['Authorization']

    return head :unprocessable_entity unless auth_token

    token = auth_token.split(' ').last
    BlacklistedToken.create(token: token)

    head :ok
  end

  private

  def user_params
    params.permit(:username, :password)
  end

  def create_token
    encode_token({ user_id: @user.id, exp: EXPIRATION_TIME })
  end
end

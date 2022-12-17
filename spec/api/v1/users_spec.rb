require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  context 'with valid params' do
    context 'POST create' do
      let(:user) { User.last }
      let(:token) { JWT.encode({ user_id: user.id, exp: Api::V1::UsersController::EXPIRATION_TIME }, Api::V1::ApiController::SECRET) }
      let(:expect_response) do
        {
          "user": {
            "id": user.id,
            "username": user.username,
            "password_digest": user.password_digest,
            "created_at": user.created_at,
            "updated_at": user.updated_at
          },
          "token": token
        }.to_json
      end

      it 'returns a new user with its token' do
        post :create, params: { username: 'new user', password: '123456' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expect_response)
      end
    end

    context 'POST login' do
      let!(:user) { create(:user) }
      let!(:token) { JWT.encode({ user_id: user.id, exp: Api::V1::UsersController::EXPIRATION_TIME }, Api::V1::ApiController::SECRET) }
      let!(:expect_response) do
        {
          "user": {
            "id": user.id,
            "username": user.username,
            "password_digest": user.password_digest,
            "created_at": user.created_at,
            "updated_at": user.updated_at
          },
          "token": token
        }.to_json
      end

      it 'returns an existing user with its token' do
        post :login, params: { username: user.username, password: user.password }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expect_response)
      end
    end

    context 'logout' do
      let!(:user) { create(:user) }
      let!(:token) { JWT.encode({ user_id: user.id, exp: Api::V1::UsersController::EXPIRATION_TIME }, Api::V1::ApiController::SECRET) }

      it 'blacklists the user token' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        delete :logout

        expect(BlacklistedToken.find_by(token: token)).to be_truthy
      end
    end
  end

  context 'with invalid params' do
    context 'POST create' do
      it 'has http status unprocessable entity' do
        post :create, params: { username: 'new user', password: '123' }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'POST login' do
      it 'has http status unprocessable entity' do
        post :login, params: { username: 'new user', password: '12345678' }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'DELETE logout' do
      it 'has http status unprocessable entity' do
        delete :logout

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

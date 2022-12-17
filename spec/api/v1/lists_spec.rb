require 'rails_helper'

describe Api::V1::ListsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:token) { JWT.encode({ user_id: user.id }, 'secret_word') }
  let!(:list1) { create(:list, user: user) }
  let!(:list2) { create(:list, user: user, status: :hidden) }
  let!(:list_item1) { create(:list_item, list: list1) }

  context 'GET index' do
    let!(:expect_response) do
      {
        "lists": [
          {
            "id": list1.id,
            "name": 'List 1',
            "status": 'visible',
            "user_id": user.id,
            "created_at": list1.created_at,
            "updated_at": list1.updated_at,
            "list_items": [list_item1]
          }
        ]
      }.to_json
    end

    it 'returns all visible lists' do
      get :index

      expect(response.body).to eq(expect_response)
    end
  end

  context 'when an user is logged in' do
    context 'POST create' do
      it 'returns the created list' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        post :create, params: { name: 'My List' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'PATCH update' do
      it 'has http status ok' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        patch :update, params: { id: list1.id, name: 'My List UPDATED' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'DELETE destroy' do
      it 'has http status ok' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        delete :destroy, params: { id: list1.id }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when an user is not logged in' do
    it 'has http status unauthorized' do
      post :create, params: { name: 'My List' }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

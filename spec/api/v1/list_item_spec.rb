require 'rails_helper'

describe Api::V1::ListItemsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:token) { JWT.encode({ user_id: user.id }, 'secret_word') }
  let!(:list1) { create(:list, user: user) }
  let!(:list_item1) { create(:list_item, list: list1) }
  let!(:list_item2) { create(:list_item, list: list1, short_name: 'List Item 2') }

  context 'with valid params' do
    context 'GET index' do
      let!(:expect_response) do
        {
          "list_items": [
            {
              "id": list_item1.id,
              "short_name": 'List Item 1',
              "description": nil,
              "completion_status": 'started',
              "list_id": list1.id,
              "created_at": list_item1.created_at,
              "updated_at": list_item1.updated_at
            },
            {
              "id": list_item2.id,
              "short_name": 'List Item 2',
              "description": nil,
              "completion_status": 'started',
              "list_id": list1.id,
              "created_at": list_item2.created_at,
              "updated_at": list_item2.updated_at
            }
          ]
        }.to_json
      end

      it 'returns all list items from a given list' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        get :index, params: { list_id: list1.id }

        expect(response.body).to eq(expect_response)
      end
    end

    context 'POST create' do
      it 'returns the created list item' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        post :create, params: { list_id: list1.id, short_name: 'My List item' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'PATCH update' do
      it 'has http status ok' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        patch :update, params: { list_id: list1.id, id: 1, name: 'My List item UPDATED' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'DELETE destroy' do
      it 'has http status ok' do
        request.headers.merge!({ 'Authorization': "Bearer #{token}" })
        delete :destroy, params: { list_id: list1.id, id: 1 }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'with invalid params' do
    it 'has http status unauthorized' do
      post :create, params: { list_id: list1.id, short_name: nil }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

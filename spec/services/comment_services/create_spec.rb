require 'rails_helper'

RSpec.describe 'Comment create', type: :request do
  describe 'publication' do
    let(:user) { create(:user) }
    context 'without authentication' do
      it 'returns unauthorized' do
        patch '/users/update'
        expect(response).to have_http_status(401)
      end
    end

    context 'with valid params' do
      let(:valid_params) do
        {
          comment: 'Description of the comment',
          commentable_id: create(:publication).id,
          commentable_type: 'Publication'
        }
      end

      before { sign_in user }
      it 'returns success' do
        post '/comments/create', params: valid_params
        result = JSON(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('Comment created successfully')
        expect(result['data']['comment']).to eq('Description of the comment')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          comment: 'Description of the comment',
          commentable_type: 'jaja',
          commentable_id: nil
        }
      end

      before { sign_in user }
      it 'returns error' do
        post '/comments/create', params: invalid_params
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível cadastrar o comentário')
      end
    end
  end
end

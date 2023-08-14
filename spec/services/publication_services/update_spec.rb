require 'rails_helper'

RSpec.describe 'Publications Update', type: :request do
  describe 'PATCH /publications/:id' do
    context 'without authentication' do
      it 'returns unauthorized' do
        patch '/users/update'
        expect(response).to have_http_status(401)
      end
    end

    context 'update successfully' do
      let(:user) { create(:user) }
      let(:publication) { create(:publication, user: user) }

      let(:valid_params) do
        {
          title: 'Test2',
          description: 'Test2'
        }
      end

      before { sign_in user }

      it 'returns success' do
        patch "/publications/#{publication.id}", params: valid_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('Publication updated successfully')
        expect(result['data']['title']).to eq('Test2')
        expect(result['data']['description']).to eq('Test2')
      end
    end

    context 'update failed params' do
      let(:user) { create(:user) }
      let(:publication) { create(:publication, user: user) }

      let(:invalid_params) do
        {
          title: '',
          description: ''
        }
      end

      before { sign_in user }

      it 'returns failed' do
        patch "/publications/#{publication.id}", params: invalid_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar a publicação')
        expect(result['failure']['title']).to include('tem que ser prenchido')
        expect(result['failure']['description']).to include('tem que ser prenchido')
      end
    end

    context 'update failed user' do
      let(:user) { create(:user) }
      let(:user2) { create(:user2) }
      let(:publication) { create(:publication, user: user) }

      let(:invalid_params) do
        {
          title: 'Test2',
          description: 'Test2'
        }
      end

      before { sign_in user2 }

      it 'returns failed' do
        patch "/publications/#{publication.id}", params: invalid_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar a publicação')
        expect(result['failure']).to eq('Publication not found')
      end
    end

    context 'publication not found' do
      let(:user) { create(:user) }
      let(:publication_id) { 0 }

      before { sign_in user }

      it 'returns not found' do
        patch "/publications/#{publication_id}"
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar a publicação')
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Publications show', type: :request do
  describe 'publication' do
    let!(:user) do
      User.create(
        name: 'John Doe',
        email: 'test@example.com',
        password: '@Aa12345',
        password_confirmation: '@Aa12345'
      )
    end

    let!(:user2) do
      User.create(
        name: 'Jane Smith',
        email: 'test2@example.com',
        password: '@Aa12345',
        password_confirmation: '@Aa12345'
      )
    end

    let!(:publication) do
      Publication.create(
        title: 'Test',
        description: 'Test',
        user_id: user.id
      )
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        patch '/users/update'
        expect(response).to have_http_status(401)
      end
    end

    context 'failed destroy' do
      before { sign_in user2 }

      it 'returns unauthorized' do
        delete "/publications/#{publication.id}"
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível excluir a publicação')
      end
    end

    context 'successful destroy' do
      before { sign_in user }

      it 'returns success' do
        delete "/publications/#{publication.id}"
        result = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('Publicação excluída com sucesso')
      end
    end

    context 'id not found' do
      before { sign_in user }

      it 'returns not found' do
        delete '/publications/0'
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível excluir a publicação')
        expect(result['failure']).to eq('Publication not found')
      end
    end
  end
end

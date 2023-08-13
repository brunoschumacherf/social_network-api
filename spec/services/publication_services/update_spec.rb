require 'rails_helper'

RSpec.describe 'Publications update', type: :request do
  describe 'publication' do
    let(:user) do User.create(
      name: 'John Doe',
      email: 'test@example.com',
      password: '@Aa12345',
      password_confirmation: '@Aa12345'
    )
    end
    let(:user2) do User.create(
      name: 'John Doe',
      email: 'test2@example.com',
      password: '@Aa12345',
      password_confirmation: '@Aa12345'
    )
    end

    let(:publication) do Publication.create(
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

    context 'update successfully' do
      let(:valid_params) do
        {
          title: 'Test2',
          description: 'Test2',
          publication_id: publication.id
        }
      end
      before { sign_in user }
      it 'returns success' do
        patch "/publications/#{publication.id}", params: valid_params
        result = JSON(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('Publication updated successfully')
      end
    end

    context 'update failed params' do
      let(:invalid_params) do
        {
          title: '',
          description: ''
        }
      end
      before { sign_in user }
      it 'returns failed' do
        patch "/publications/#{publication.id}", params: invalid_params
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar a publicação')
      end
    end

    context 'update failed user' do
      let(:invalid_params) do
        {
          title: 'Test2',
          description: 'Test2'
        }
      end
      before { sign_in user2 }
      it 'returns failed' do
        patch "/publications/#{publication.id}", params: invalid_params
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar a publicação')
      end
    end
  end
end

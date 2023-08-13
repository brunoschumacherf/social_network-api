require 'rails_helper'

RSpec.describe 'Comments Update', type: :request do
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

    let(:comment) do Comment.create(
      comment: 'Test',
      user_id: user.id,
      commentable_id: publication.id,
      commentable_type: 'Publication'
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
          comment: 'Test2'
        }
      end
      before { sign_in user }
      it 'returns success' do
        patch "/comments/#{comment.id}", params: valid_params
        result = JSON(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('comment updated successfully')
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
        patch "/comments/#{comment.id}", params: invalid_params
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar o comentário')
      end
    end

    context 'update failed user' do
      let(:invalid_params) do
        {
          comment: 'Test2'
        }
      end
      before { sign_in user2 }
      it 'returns failed' do
        patch "/comments/#{comment.id}", params: invalid_params
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar o comentário')
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Comments Update', type: :request do
  describe 'comments' do
    let(:user) { create(:user) }
    let(:user2) { create(:user, email: 'test2@example.com') }
    let(:publication) { create(:publication, user: user) }
    let(:comment) { create(:comment, user: user, commentable: publication) }

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
        expect(result['message']).to eq('Comment updated successfully')
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

require 'rails_helper'

RSpec.describe 'Comment Destroy', type: :request do
  describe 'publication' do
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

    context 'delete failed params' do
      before { sign_in user }
      it 'returns failed' do
        delete "/comments/0"
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível deletar o comentário')
      end
    end

    context 'delete failed user' do
      before { sign_in user2 }
      it 'returns failed' do
        delete "/comments/#{comment.id}"
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível deletar o comentário')
      end
    end

    context 'delete successfully' do
      before { sign_in user }
      it 'returns success' do
        delete "/comments/#{comment.id}"
        result = JSON(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('Comment deleted successfully')
      end
    end
  end
end

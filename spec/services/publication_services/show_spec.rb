require 'rails_helper'

RSpec.describe 'Publications Show', type: :request do
  describe 'GET /publications/show/:id' do
    context 'without authentication' do
      it 'returns unauthorized' do
        get '/publications/show/1'
        expect(response).to have_http_status(401)
      end
    end

    context 'with valid publication' do
      let(:user) { create(:user) }
      let(:publication) { create(:publication, user: user) }

      before { sign_in user }

      it 'returns the publication' do
        get "/publications/show/#{publication.id}"
        result = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(result['data']['title']).to eq(publication.title)
        expect(result['data']['description']).to eq(publication.description)
      end
    end

    context 'with invalid publication id' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'returns not found' do
        get '/publications/show/0'
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível Buscar as publicações')
      end
    end
  end
end

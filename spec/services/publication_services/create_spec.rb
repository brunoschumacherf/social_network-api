require 'rails_helper'

RSpec.describe 'Publications Create', type: :request do
  describe 'POST /publications/create' do
    context 'without authentication' do
      it 'returns unauthorized' do
        post '/publications/create'
        expect(response).to have_http_status(401)
      end
    end

    context 'with valid params' do
      let(:user) { create(:user) }
      let(:valid_params) do
        {
          title: 'Title',
          description: 'Description of the publication'
        }
      end

      before { sign_in user }

      it 'creates a new publication' do
        post '/publications/create', params: valid_params
        result = JSON(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('Publication created successfully')
        expect(result['data']['title']).to eq('Title')
        expect(result['data']['description']).to eq('Description of the publication')
      end
    end

    context 'with invalid params' do
      let(:user) { create(:user) }
      let(:invalid_params) do
        {
          title: '',
          description: 'Description of the publication'
        }
      end

      before { sign_in user }

      it 'returns error' do
        post '/publications/create', params: invalid_params
        result = JSON(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível cadastrar a publicação')
        expect(result['failure']['title']).to include('tem que ser prenchido')
      end
    end
  end
end

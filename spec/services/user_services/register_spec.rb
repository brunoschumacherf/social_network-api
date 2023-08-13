require 'rails_helper'

RSpec.describe 'User Registration API', type: :request do
  describe 'POST /users/register' do
    context 'with valid params' do
      let(:valid_params) do
        {
          name: 'John Doe',
          email: "#{Random.rand(1000)}test@test.com",
          password: '@Aa12345',
          password_confirmation: '@Aa12345'
        }
      end

      it 'registers a new user' do
        post '/users/register', params: valid_params
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(result['data']['name']).to eq(valid_params[:name])
        expect(result['data']['email']).to eq(valid_params[:email])
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          name: 'John Doe',
          email: 'invalid_email',
          password: 'Password123',
          password_confirmation: 'DifferentPassword'
        }
      end

      it 'returns error messages' do
        post '/users/register', params: invalid_params
        expect(response).to have_http_status(400)
        result = JSON.parse(response.body)
        expect(result['message']).to eq('Não foi possível cadastrar o usuário')
        expect(result['failure']['password_confirmation']).to eq(['must be equal to password'])
        expect(result['failure']['email']).to eq(['must be a valid email'])
        expect(result['failure']['password']).to eq(['must be at least 8 characters'])
      end
    end
  end
end

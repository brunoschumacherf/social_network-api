require 'rails_helper'

RSpec.describe 'User Signin API', type: :request do
  let(:user) do
    User.create(
      name: 'John Doe',
      email: 'john@example.com',
      password: '@Aa123456',
      password_confirmation: '@Aa123456'
    )
  end

  describe 'POST /users/signin' do
    context 'with valid params' do
      let(:valid_params) do
        {
          email: user.email,
          password: '@Aa123456'
        }
      end

      it 'logs in the user' do
        post '/users/signin', params: valid_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('User successfully logged in')
        expect(result['data']['name']).to eq(user.name)
        expect(result['data']['email']).to eq(user.email)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          email: 'invalid@example.com',
          password: '@Aa123456'
        }
      end

      it 'returns error messages' do
        post '/users/signin', params: invalid_params
        expect(response).to have_http_status(400)
        result = JSON.parse(response.body)
        expect(result['message']).to eq('Não foi possível logar o usuário')
        expect(result['failure']).to eq('User not found')
      end
    end

    context 'invalid password' do
      let(:invalid_params) do
        {
          email: user.email,
          password: 'InvalidPassword'
        }
      end

      it 'returns error messages' do
        post '/users/signin', params: invalid_params
        expect(response).to have_http_status(400)
        result = JSON.parse(response.body)
        expect(result['message']).to eq('Não foi possível logar o usuário')
        expect(result['failure']).to eq('Invalid password')
      end
    end
  end
end

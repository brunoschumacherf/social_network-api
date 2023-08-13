require 'rails_helper'

RSpec.describe 'User Update API', type: :request do
  let(:user) do
    User.create(
      name: 'John Doe',
      email: 'test@example.com',
      password: '@Aa12345',
      password_confirmation: '@Aa12345'
    )
  end

  describe 'PATCH /users/update' do
    context 'without authentication' do
      it 'returns unauthorized' do
        patch '/users/update'
        expect(response).to have_http_status(401)
      end
    end

    context 'with valid params' do
      let(:valid_params) do
        {
          name: 'New Name',
          email: 'new@example.com',
          password: '@Aa12342',
          password_confirmation: '@Aa12342',
          current_password: '@Aa12345'
        }
      end
      before { sign_in user }
      it 'updates the user' do
        patch '/users/update', params: valid_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(result['message']).to eq('User updated successfully')
        expect(result['data']['name']).to eq('New Name')
        expect(result['data']['email']).to eq('new@example.com')
      end
    end

    context 'with invalid current password' do
      let(:invalid_current_password_params) do
        {
          name: 'New Name',
          email: 'new@example.com',
          password: '@Aa12342',
          password_confirmation: '@Aa12342',
          current_password: 'InvalidPassword'
        }
      end
      before { sign_in user }
      it 'returns invalid password error' do
        patch '/users/update', params: invalid_current_password_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['errors']['step']['invalid_password']).to eq('Invalid password')
        expect(result['message']).to eq('Não foi possível atualizar o usuário')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          email: 'invalid_email',
          password: '@Aa13342',
          password_confirmation: '@A21342',
          current_password: '@Aa123456'
        }
      end
      before { sign_in user }
      it 'returns error messages' do
        patch '/users/update', params: invalid_params
        result = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(result['message']).to eq('Não foi possível atualizar o usuário')
        expect(result['failure']['password_confirmation']).to include('must be equal to password')
        expect(result['failure']['email']).to include('must be a valid email')
      end
    end
  end
end

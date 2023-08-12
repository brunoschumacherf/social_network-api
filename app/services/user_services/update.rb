module UserServices
  class Update < SocialNetworkServices
    def initialize(params, current_user)
      @params = params
      @user = current_user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      yield validate_current_password(@user, valid_params[:current_password])
      user = yield update_user(@user, valid_params)
      Success[presenter(@user), user]
    end

    private

    def validate_params(params)
      parameters do
        optional(:name).value(:string)
        optional(:email).value(:string)
        optional(:password).value(:string)
        optional(:password_confirmation).value(:string)
        required(:current_password).filled(:string)
      end
      rules do
        rule(:password_confirmation) do
          key.failure('must be equal to password') if value != params[:password]
        end
        rule(:password) do
          key.failure('must be at least 8 characters') unless value.blank? || value.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$/)
        end
        rule(:email) do
          key.failure('must be a valid email') unless value.blank? || value.match(/^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/)
        end
      end
      validate(params.to_enum)
    end

    def validate_current_password(user, current_password)
      return Success() if user.valid_password?(current_password)

      Failure[invalid_password: 'Invalid password']
    end

    def update_user(user, params)
      params.delete(:current_password)
      user.update(params)
      return Success(user) if user.valid?

      Failure[:update_user, user.errors.full_messages]
    end

    def presenter(user)
      {
        message: 'User updated successfully',
        data: {
          name: user.name,
          email: user.email,
        }
      }
    end
  end
end


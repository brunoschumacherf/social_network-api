module UserServices
  class Signin < SocialNetworkServices
    def initialize(params)
      @params = params
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      user = yield check_user(valid_params[:email])
      yield check_password(user, valid_params[:password])
      Success[presenter(user), user]
    end

    private

    def validate_params(params)
      parameters do
        required(:email).filled(:string)
        required(:password).filled(:string)
      end
      validate(params)
    end

    def check_user(email)
      user = User.find_by(email: email)
      return Success(user) if user.present?

      Failure[:not_found, 'User not found']
    end

    def check_password(user, password)
      return Success(user) if user.valid_password?(password)

      Failure[:invalid_password, 'Invalid password']
    end

    def presenter(user)
      {
        message: 'User successfully logged in',
        data: {
          name: user.name,
          email: user.email,
        }
      }
    end
  end
end

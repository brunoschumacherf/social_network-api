module UserServices
  class Register < SocialNetworkServices
    def initialize(params)
      @params = params
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      user = yield create_user(valid_params)
      Success[presenter(user), user]
    end

    private
    def validate_params(params)
      parameters do
        required(:name).filled(:string)
        required(:email).filled(:string)
        required(:password).filled(:string)
        required(:password_confirmation).filled(:string)
      end
      rules do
        rule(:password_confirmation) do
          key.failure('must be equal to password') if value != params[:password]
        end
        rule(:password) do
          key.failure('must be at least 8 characters') unless value.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$/)
        end
        rule(:email) do
          key.failure('must be a valid email') unless value.match(/^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/)
        end
      end
      validate(params.to_enum)
    end

    def create_user(params)
      user = User.new(params)
      if user.save
        Success(user)
      else
        Failure[:create_user, user.errors.full_messages]
      end
    end

    def presenter(user)
      {
        message: 'User created successfully',
        data: {
          name: user.name,
          email: user.email,
        }
      }
    end
  end
end

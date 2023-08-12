class UserController < ApiController
  def register
    UserServices::Register.call(params) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível cadastrar o usuário'
        render json: result, status: 400
      end

      on.success do |presenter, user|
        sign_in(user)
        render json: presenter, status: 200
      end
    end
  end

  def signin
    UserServices::Signin.call(params) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível logar o usuário'
        render json: result, status: 400
      end

      on.success do |presenter, user|
        sign_in(user)
        render json: presenter, status: 200
      end
    end
  end

  def signout
    sign_out
    render json: { message: 'Usuário deslogado com sucesso' }, status: 200
  end
end

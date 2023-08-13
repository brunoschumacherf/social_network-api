class ApiController < ApplicationController
  before_action :check_user, except: %i[signin register]

  def check_user
    return if current_user

    render json: { message: 'Usuário não autenticado' }, status: 401
  end
end

class PublicationsController < ApiController
  def create
    PublicationServices::Create.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível cadastrar a publicação'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def show
    PublicationServices::Show.call(params) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível Buscar as publicações'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def get_all
    PublicationServices::GetAll.call(params) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível Buscar as publicações'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def my_publications
    PublicationServices::GetPublicationUser.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível buscar as publicações'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end


  def update
    PublicationServices::Update.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível atualizar a publicação'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def destroy
    PublicationServices::Destroy.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível excluir a publicação'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end
end


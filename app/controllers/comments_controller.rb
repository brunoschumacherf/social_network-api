class CommentsController < ApiController
  def create
    CommentServices::Create.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível cadastrar o comentário'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def destroy
    CommentServices::Destroy.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível deletar o comentário'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def update
    CommentServices::Update.call(params, current_user) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível atualizar o comentário'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end

  def show
    CommentServices::Show.call(params) do |on|
      on.failure do |_step, failure, result|
        result[:failure] = failure
        result[:message] = 'Não foi possível encontrar o comentário'
        render json: result, status: 400
      end

      on.success do |presenter|
        render json: presenter, status: 200
      end
    end
  end
end

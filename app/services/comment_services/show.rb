module CommentServices
  class Show < SocialNetworkServices
    def initialize(params)
      @params = params
    end

    def call
      validate_params = yield validate_params(@params.permit!.to_h)
      comments = yield find_comments(validate_params[:id])
      Success(presenter(comments))
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
      end
      Success(params)
    end

    def find_comments(id)
      comments = Comment.find_by(id: id)
      return Failure(find_comments: 'comments not found') unless comments

      Success(comments)
    end

    def presenter(comments)
      {
        message: 'comments found',
        data: comments.full_map
      }
    end
  end
end

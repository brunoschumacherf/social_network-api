module CommentServices
  class Create < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      comment = yield create_comment(valid_params, @user)
      Success(presenter(comment))
    end

    private

    def validate_params(params)
      parameters do
        required(:comment).filled(:string)
        required(:commentable_id).filled(:integer)
        required(:commentable_type).filled(:string)
        optional(:archive)
      end
      rules do
        rule(:commentable_type) do
          key.failure('must be a valid type') unless %w[Publication Comment].include?(params[:commentable_type])
        end
      end
      validate(params.to_enum)
    end

    def create_comment(params, user)
      comment = Comment.new(params)
      comment.user = user
      comment.save(validate: false)
      # comment.save ? Success(comment) : Failure(comment.errors.full_messages)
      Success(comment)
    end

    def presenter(comment)
      {
        message: 'Comment created successfully',
        data: comment.full_map
      }
    end
  end
end



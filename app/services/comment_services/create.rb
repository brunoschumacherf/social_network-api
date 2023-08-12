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
        optional(:archive)
      end
      validate(params.to_enum)
    end

    def create_comment(params, user)
      comment = Comment.new(params)
      comment.user = user
      comment.commentable = 0
      comment.save(validate: false)
      # comment.save ? Success(comment) : Failure(comment.errors.full_messages)
      Success(comment)
    end

    def presenter(comment)
      {
        message: 'Publication created successfully',
        data: comment.full_map
      }
    end
  end
end



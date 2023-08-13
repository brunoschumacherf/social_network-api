module CommentServices
  class Update < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      comment = yield find_comment(valid_params[:id])
      yield valid_user_for_comment(comment, @user)
      comment = yield update_comment(comment, valid_params)
      Success(presenter(comment))
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
        optional(:comment).filled(:string)
        optional(:archive)
      end
      validate(params.to_enum)
    end

    def find_comment(id)
      comment = Comment.find_by(id: id)
      if comment
        Success(comment)
      else
        Failure[:comment_not_found, 'Comment not found']
      end
    end

    def valid_user_for_comment(comment, user)
      if comment.user_id == user.id
        Success(comment)
      else
        Failure[:invalid_user, 'Invalid user']
      end
    end

    def update_comment(comment, params)
      if comment.update(params.except(:id))
        Success(comment)
      else
        Failure[:comment_not_updated, comment.errors.full_messages]
      end
    end

    def presenter(comment)
      {
        message: 'comment updated successfully',
        data: comment.full_map
      }
    end
  end
end

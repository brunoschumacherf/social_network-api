module CommentServices
  class Update < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      comment = yield find_comment(valid_params[:id], @user)
      comment = yield update_comment(comment, valid_params)
      Success(presenter(comment))
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
        optional(:comment).maybe(:string)
        optional(:archive)
      end
      validate(params.to_enum)
    end

    def find_comment(id, user)
      comment = user.comments.find_by(id: id)
      if comment
        Success(comment)
      else
        Failure[:comment_not_found, 'Comment not found']
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
        message: 'Comment updated successfully',
        data: comment.full_map
      }
    end
  end
end

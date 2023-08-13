module CommentServices
  class Destroy < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      validate_params = yield validate_params(@params.permit!.to_h)
      comments = yield find_comments(validate_params[:id], @user)
      yield delete_comments(comments)
      Success({message: 'Comment deleted successfully'})
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
      end
      validate(params.to_enum)
    end

    def find_comments(id, user)
      comments = user.comments.find_by(id: id)
      if comments.present?
        Success(comments)
      else
        Failure[:find_comment, 'comments not found']
      end
    end

    def delete_comments(comments)
      if comments.destroy
        Success()
      else
        Failure[:delete_comments, comments.errors.full_messages.to_sentence]
      end
    end
  end
end

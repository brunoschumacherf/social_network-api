module PublicationServices
  class Destroy < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      validate_params = yield validate_params(@params.permit!.to_h)
      publication = yield find_publication(validate_params[:id])
      yield valid_user_for_publication(publication, @user)
      yield delete_publication(publication)
      Success({message: 'Publication deleted successfully'})
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
      end
      validate(params.to_enum)
    end

    def find_publication(id)
      publication = Publication.where(id: id).first
      if publication.present?
        Success(publication)
      else
        Failure({errors: 'Publication not found'})
      end
    end

    def valid_user_for_publication(publication, user)
      return Success() if publication.user_id == user.id

      Failure({errors: "You can't delete this publication"})
    end

    def delete_publication(publication)
      if publication.destroy
        Success()
      else
        Failure({errors: publication.errors.full_messages.to_sentence})
      end
    end
  end
end

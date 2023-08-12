module PublicationServices
  class Update < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      yield find_publication(valid_params[:id])
      yield valid_user_for_publication(publication, @user)
      publication = yield update_publication(publication, valid_params)
      Success(presenter(publication))
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
        optional(:title).filled(:string)
        optional(:description).filled(:string)
        optional(:archive)
      end
      validate(params.to_enum)
    end

    def find_publication(id)
      publication = Publication.find_by(id: id)
      publication ? Success(publication) : Failure[:publication_not_found, 'Publication not found']
    end

    def valid_user_for_publication(publication, user)
      if publication.user_id == user.id
        Success(publication)
      else
        Failure[:invalid_user, 'Invalid user']
      end
    end

    def update_publication(publication, params)
      return Success() if publication.user_id == user.id

      Failure({errors: "You can't delete this publication"})
    end

    def presenter(publication)
      {
        message: 'Publication updated successfully',
        data: publication.full_map
      }
    end
  end
end

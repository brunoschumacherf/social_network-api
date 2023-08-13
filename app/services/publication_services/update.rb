module PublicationServices
  class Update < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      publication = yield find_publication(valid_params[:id], @user)
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

    def find_publication(id, user)
      publication = user.publications.find_by(id: id)
      return Success(publication) if publication

      Failure[:not_found, 'Publication not found']
    end

    def update_publication(publication, valid_params)
      if publication.update(valid_params.except(:id))
        Success(publication)
      else
        Failure[:failed, publication.errors.full_messages.join(', ')]
      end
    end

    def presenter(publication)
      {
        message: 'Publication updated successfully',
        data: publication.full_map
      }
    end
  end
end

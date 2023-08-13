module PublicationServices
  class Show < SocialNetworkServices
    def initialize(params)
      @params = params
    end

    def call
      validate_params = yield validate_params(@params.permit!.to_h)
      publication = yield find_publication(validate_params[:id])
      Success(presenter(publication))
    end

    private

    def validate_params(params)
      parameters do
        required(:id).filled(:integer)
      end
      Success(params)
    end

    def find_publication(id)
      publication = Publication.find_by(id: id)
      return Failure[:find_publication, 'Publication not found'] unless publication

      Success(publication)
    end

    def presenter(publication)
      {
        message: 'Publication found',
        data: publication.full_map
      }
    end
  end
end

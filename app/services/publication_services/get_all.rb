module PublicationServices
  class GetAll < SocialNetworkServices
    def initialize(params)
      @params = params
    end

    def call
      validate_params = yield validate_params(@params.permit!.to_h)
      publications = yield get_publications(validate_params)
      Success(presenter(publications))
    end

    private

    def validate_params(params)
      parameters do
        optional(:page).maybe(:integer)
        optional(:per_page).maybe(:integer)
      end
      validate(params.to_enum)
    end

    def get_publications(params)
      publications = Publication.all
      publications = publication.page(params[:page]).per(params[:per_page]) if params[:page].present? && params[:per_page].present?
      Success(publications)
    end

    def presenter(publications)
      Publication.map_publications(publications)
    end
  end
end

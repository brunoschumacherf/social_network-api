module PublicationServices
  class Create < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      valid_params = yield validate_params(@params.permit!.to_h)
      publication = yield create_publication(valid_params, @user)
      Success(presenter(publication))
    end

    private

    def validate_params(params)
      parameters do
        required(:title).filled(:string)
        optional(:description).maybe(:string)
        optional(:archive)
      end
      validate(params.to_enum)
    end

    def create_publication(params, user)
      publication = Publication.new(params)
      publication.user_id = user.id
      publication.save
      Success(publication)
    end

    def presenter(publication)
      {
        message: 'Publication created successfully',
        data: publication.map_create
      }
    end
  end
end



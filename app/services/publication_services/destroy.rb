module PublicationServices
  class Destroy < SocialNetworkServices
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      validate_params = yield validate_params(@params.permit!.to_h)
      publication = yield find_publication(validate_params[:id], @user)
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

    def find_publication(id, user)
      publication = user.publications.find_by(id: id)
      if publication.present?
        Success(publication)
      else
        Failure[:find_publication, 'Publication not found']
      end
    end


    def delete_publication(publication)
      if publication.destroy
        Success()
      else
        Failure[:delete_publication, ublication.errors.full_messages.to_sentence]
      end
    end
  end
end

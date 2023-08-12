class SocialNetworkServices
  require 'dry/monads/result'
  require 'dry/matcher/result_matcher'
  include Dry::Monads[:result, :do]

  def self.call(*args, &block)
    result = new(*args, &block).call
    if result.failure?
      Rails.logger.info "\n
                          ############### Failure Service #{self} ###############\n
                          step: #{result.failure.first}\n
                          reason: #{result.failure.last}\n"
    end

    result.failure << {} if result.failure?

    if result.failure?
      result.failure << { errors: { step: result.failure.first, failure: result.failure.last } }
    end

    if block_given?
      Dry::Matcher::ResultMatcher.call(result, &block)
    else
      result
    end
  end

  private

  def parameters(&block)
    @parameters = block
  end

  def rules(&block)
    @rules = block
  end

  def validator
    local_parameters = @parameters
    local_rules      = @rules

    @validator ||= Class.new(::BaseContract) do
      params do
        instance_exec(&local_parameters)
      end
      instance_exec(&local_rules) if local_rules
    end.new
  end

  def validate(data)
    result = validator.call(data.to_h)
    return Failure[:validate_params, result.errors.to_h] if result.failure?

    Success(result.to_h)
  end
end

class BaseContract < Dry::Validation::Contract
  config.messages.default_locale = 'pt-BR'
  config.messages.backend = :i18n
end

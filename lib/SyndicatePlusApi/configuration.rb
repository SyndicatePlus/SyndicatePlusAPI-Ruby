require "logger"
require "confiture"

module SyndicatePlusApi

  # Rails initializer configuration.
  #
  # Expects at least +secret+ and +key+ for the API call:
  #
  #   SyndicatePlusApi::Configuration.configure do |config|
  #     config.secret         = 'your-secret'
  #     config.key            = 'your-key'
  #     config.version        = 'your-version'
  #   end
  #
  # Confiture is used as a basis for configuration. Have a look at the documentation[https://github.com/phoet/confiture] for more configuration styles.
  #
  # ==== Options:
  #
  # [secret] the API secret key (required)
  # [key] the API access key (required)
  # [host] the host, which defaults to 'http://api.syndicateplus.com'
  # [logger] a different logger than logging to STDERR (nil for no logging)
  # [version] a custom version of the API calls. Default is 0

  class Configuration
    include Confiture::Configuration
    confiture_allowed_keys(:secret, :key, :host, :version, :logger)
    confiture_mandatory_keys(:secret, :key)
    confiture_defaults({
      :secret        => '',
      :key           => '',
      :associate_tag => '',
      :host          => 'http://api.syndicateplus.com',
      :version       => '0',
      :logger        => Logger.new(STDERR)
    })
  end
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sampleproject
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: false,
        view_specs:false,
        helper_specs:false,
        routing_spec:false,
        controller_spec: false,
        request_spec: true
    end

    # 認証用トークンをremoteフォームに埋め込み
    config.action_view.embed_authenticity_token_in_remote_forms= true
  end
end

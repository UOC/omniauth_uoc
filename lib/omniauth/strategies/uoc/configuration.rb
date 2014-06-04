require 'rack'

module OmniAuth
  module Strategies
    class Uoc
      class Configuration
        DEFAULT_SESSION_URL = '%s/webapps/campusGateway/sessions'
        DEFAULT_CONTENT_TYPE = 'application/xml'

        attr_reader :session_url

        def initialize(params)
          parse_params params
        end

        private
        IS_NOT_URL_ERROR_MESSAGE = '%s is not a valid URL'

        def parse_params(options)
          unless options.include?(:uoc_server_url)
            raise ArgumentError.new('Either :uoc_server_url MUST be provided')
          end

          @session_url = options[:uoc_session_url] || DEFAULT_SESSION_URL % options[:uoc_server_url]

          validate_is_url 'session URL', @session_url
        end

        def validate_is_url(name, possibly_a_url)
          url = URI.parse(possibly_a_url) rescue nil
          raise ArgumentError.new(IS_NOT_URL_ERROR_MESSAGE % name) unless url.kind_of?(URI::HTTP)
        end
      end
    end
  end
end

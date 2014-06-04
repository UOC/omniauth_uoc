require 'multi_xml'
require 'faraday'

module OmniAuth
  module Strategies
    class Uoc
      class UocValidator
        SESSION_REQUEST_BODY = <<-BODY.strip
<login>
  <name>%s</name>
  <password>%s</password>
</login>
BODY

        def initialize(configuration, username, password)
          @configuration, @username, @password = configuration, username, password
          @session_uri       = URI.parse(@configuration.session_url)
          MultiXml.parser = :nokogiri
        end

        def user_info
          retrieve_user_info!
        end

        private
        def retrieve_user_info!
          response = make_session_request
          unless response.code.to_i != 200 || response.body.nil? || response.body == ''
            doc = MultiXml.parse(response.body)
            response = {}
            session = doc.xpath('//session').first
            session.children.each do |node|
              response[node.name] = node.text
            end
          else
            OmniAuth.logger.send(:warn, "(crowd) [retrieve_user_info!] response code: #{response.code.to_s}")
            OmniAuth.logger.send(:warn, "(crowd) [retrieve_user_info!] response body: #{response.body}")
            nil
          end
        end

        def make_request(uri, body=nil)

        end

        def make_session_request
          make_request(@session_uri, make_session_request_body(@username, @password))
        end

        def make_session_request_body(username,password)
          request_body = MultiXml.parse(SESSION_REQUEST_BODY)
          request_body['login']['name'] = username
          request_body['login']['password'] = password
          return request_body.to_xml
        end

      end
    end
  end
end

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
            session = doc.xpath('//session').first
            {
                :name => session.find(:fullname).first.text,
                :email => session.find(:email).first.text,
                :nickname => session.find(:login).first.text,
                :extra => {
                    :s => session.find('id').first.text,
                    :user_id => session.find('userId').first.text,
                    :user_number => session.find('userNumber').first.text,
                    :lang => session.find('lang').first.text,
                    :locale => session.find('locale').first.text,
                }
            }
          else
            OmniAuth.logger.send(:warn, "(crowd) [retrieve_user_info!] response code: #{response.code.to_s}")
            OmniAuth.logger.send(:warn, "(crowd) [retrieve_user_info!] response body: #{response.body}")
            nil
          end
        end

        def make_session_request
          conn = Faraday.new(:url => @session_uri.to_s) do |faraday|
            faraday.request  :url_encoded             # form-encode POST params
            # faraday.response :logger                  # log requests to STDOUT
            faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          end

          conn.post do |req|
            req.headers['Content-Type'] = @configuration.DEFAULT_CONTENT_TYPE
            req.body = make_session_request_body(@username, @password)
          end
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

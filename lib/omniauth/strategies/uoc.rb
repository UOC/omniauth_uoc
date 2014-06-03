require 'omniauth'
module OmniAuth
  module Strategies
    class UOC
      include OmniAuth::Strategy

      autoload :Configuration, 'omniauth/strategies/uoc/configuration'

      def initialize(app, options = {}, &block)
        options.symbolize_keys!()
        super(app, {:name=> :uoc}.merge(options), &block)
        @configuration = OmniAuth::Strategies::UOC::Configuration.new(options)
      end

      protected

      def request_phase
        if env['REQUEST_METHOD'] == 'GET'
          get_credentials
        else
          session['omniauth.uoc'] = {'username' => request['username'], 'password' => request['password']}
          redirect callback_url
        end
      end

      def get_credentials
        OmniAuth::Form.build(:title => (options[:title] || 'UOC Authentication')) do
          text_field 'Login', 'username'
          password_field 'Password', 'password'
        end.to_response
      end

      def callback_phase
        creds = session.delete 'omniauth.uoc'
        return fail!(:no_credentials) unless creds
        validator = UOCValidator.new(@configuration, creds['username'], creds['password'])
        @user_info = validator.user_info

        return fail!(:invalid_credentials) if @user_info.nil? || @user_info.empty?

        super
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
            'uid' => @user_info.delete('user'),
            'info' => @user_info
        })
      end
    end
  end
end

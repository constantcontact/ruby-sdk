#
# oauth2.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Auth
    class OAuth2
      attr_accessor :client_id, :client_secret, :redirect_uri, :props


      # Class constructor
      # @param [Hash] opts - the options to create an OAuth2 object with
      # @option opts [String] :api_key - the Constant Contact API Key
      # @option opts [String] :api_secret - the Constant Contact secret key
      # @option opts [String] :redirect_url - the URL where Constact Contact is returning the authorization code
      # @return
      def initialize(opts)
        @client_id = opts[:api_key]
        @client_secret = opts[:api_secret]
        @redirect_uri = opts[:redirect_url]
      end


      # Get the URL at which the user can authenticate and authorize the requesting application
      # @param [Boolean] server - whether or not to use OAuth2 server flow, alternative is client flow
      # @return [String] the authorization URL
      def get_authorization_url(server = true)
        response_type = server ? Util::Config.get('auth.response_type_code') : Util::Config.get('auth.response_type_token')
        params = {
          :response_type => response_type,
          :client_id     => @client_id,
          :redirect_uri  => @redirect_uri
        }
        [
          Util::Config.get('auth.base_url'),
          Util::Config.get('auth.authorization_endpoint'),
          '?',
          Util::Helpers.http_build_query(params)
        ].join
      end


      # Obtain an access token
      # @param [String] code - the code returned from Constant Contact after a user has granted access to his account
      # @return [String] the access token
      def get_access_token(code)
        params = {
          :grant_type    => Util::Config.get('auth.authorization_code_grant_type'),
          :client_id     => @client_id,
          :client_secret => @client_secret,
          :code          => code,
          :redirect_uri  => @redirect_uri
        }

        url = [
          Util::Config.get('auth.base_url'),
          Util::Config.get('auth.token_endpoint')
        ].join

        response_body = ''
        begin
          response = RestClient.post(url, params)
          response_body = JSON.parse(response)
        rescue => e
          response_body = e.respond_to?(:response) ?
            JSON.parse(e.response) :
            {'error' => '', 'error_description' => e.message}
        end

        if response_body['error_description']
          error = response_body['error_description']
          raise Exceptions::OAuth2Exception, error
        end

        response_body
      end

    end
  end
end

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
			# @param [String] client_id - Constant Contact API Key
			# @param [String] client_secret - Constant Contact secret key
			# @param [String] redirect_uri - URL where Constact Contact is returning  the authorization code
			# @return
			def initialize(client_id, client_secret, redirect_uri)
				@client_id = client_id
				@client_secret = client_secret
				@redirect_uri = redirect_uri
			end


			# Get the URL at which the user can authenticate and authorize the requesting application
			# @param [Boolean] server - Whether or not to use OAuth2 server flow, alternative is client flow
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
			# @param [String] code - code returned from Constant Contact after a user has granted access to their account
			# @return [String] access token
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
					if response_body['error']
						raise Exceptions::OAuth2Exception, response_body['error'] + ': ' + response_body['error_description']
					end
				rescue => e
					response_body = JSON.parse(e.response)
					if response_body['error']
						raise Exceptions::OAuth2Exception, response_body['error'] + ': ' + response_body['error_description']
					end
				end

				response_body
			end

		end
	end
end

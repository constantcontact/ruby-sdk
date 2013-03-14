#
# base_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class BaseService

			class << self

				protected

				# Helper function to return required headers for making an http request with constant contact
				# @param [String] access_token - OAuth2 access token to be placed into the Authorization header
				# @return [Hash] - authorization headers
				def get_headers(access_token)
					{
						:content_type   => 'application/json',
						:accept         => 'application/json',
						:authorization  => "Bearer #{access_token}"
					}
				end

			end
		end
	end
end
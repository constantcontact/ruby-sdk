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


				# Helper function to build a url depending on the offset and limit
				# @param [String] url
				# @param [Integer] offset
				# @param [Integer] limit
				# @return [String] - resulting url
				def paginate_url(url, offset = nil, limit = nil)
					params = {}
					params[:offset] = offset if offset
					params[:limit] = limit if limit
					unless params.empty?
						url = url + '?' + Util::Helpers.http_build_query(params)
					end
					url
				end

			end
		end
	end
end
#
# email_address_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class EmailAddressService < BaseService
			class << self

				# Get the verified emails from account
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @return [Array<EmailAddress>]
				def get_verified(access_token)
					url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.verified_email_addresses')
					response = RestClient.get(url, get_headers(access_token))
					email_addresses = []
					JSON.parse(response.body).each do |email_address|
						email_addresses << Components::EmailAddress.create(email_address)
					end
					email_addresses
				end

			end
		end
	end
end
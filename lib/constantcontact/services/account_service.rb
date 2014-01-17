#
# email_address_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class AccountService < BaseService
      class << self

        # Get all verified email addresses associated with an account
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @param [Hash] params - hash of query parameters/values to append to the request
        # @return [Array<VerifiedEmailAddress>]
        def get_verified_email_addresses(access_token, params)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.account_verified_addresses')
          url = build_url(url, params)
          response = RestClient.get(url, get_headers(access_token))
          email_addresses = []
          JSON.parse(response.body).each do |email_address|
            email_addresses << Components::VerifiedEmailAddress.create(email_address)
          end
          email_addresses
        end

      end
    end
  end
end
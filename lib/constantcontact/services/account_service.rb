#
# email_address_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class AccountService < BaseService
      class << self

        # Get the verified emails from account
        # @param [String] access_token - Constant Contact OAuth2 access token
        # @return [Array<VerifiedEmailAddress>]
        def get_verified_email_addresses(access_token)
          url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.account_verified_addresses')
          url = build_url(url)
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
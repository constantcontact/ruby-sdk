#
# account_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class AccountService < BaseService

      # Get a summary of account information
      # @return [AccountInfo]
      def get_account_info()
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.account_info')
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        Components::AccountInfo.create(JSON.parse(response.body))
      end


      # Get all verified email addresses associated with an account
      # @param [Hash] params - hash of query parameters/values to append to the request
      # @return [Array<VerifiedEmailAddress>]
      def get_verified_email_addresses(params)
        url = Util::Config.get('endpoints.base_url') + Util::Config.get('endpoints.account_verified_addresses')
        url = build_url(url, params)
        response = RestClient.get(url, get_headers())
        email_addresses = []
        JSON.parse(response.body).each do |email_address|
          email_addresses << Components::VerifiedEmailAddress.create(email_address)
        end
        email_addresses
      end

    end
  end
end

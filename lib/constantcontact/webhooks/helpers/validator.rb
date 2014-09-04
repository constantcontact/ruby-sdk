#
# validator.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Webhooks
    module Helpers
      class Validator
        class << self

          # Validate the request received from Constant Contact.
          # Compute the HMAC digest and compare it to the value in the x-ctct-hmac-sha256 header.
          # If they match, you can be sure that the webhook was sent by Constant Contact and the message has not been compromised.
          # @param [String] secret The Constant Contact secret key
          # @param [String] hmac The value received in the x-ctct-hmac-sha256 header.
          # @param [String] data The body message from the POST received from ConstantContact in Webhook callback.
          # @return true if the computed vs. received values match; false otherwise.
          def validate(secret, hmac, data)
            digest = OpenSSL::Digest.new('sha256')
            calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip
            calculated_hmac == hmac
          end

        end
      end
    end
  end
end
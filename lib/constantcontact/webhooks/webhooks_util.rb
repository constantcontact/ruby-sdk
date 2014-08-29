#
# webhooks_util.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  class WebhooksUtil
    attr_accessor :client_secret

    # Class constructor
    # @param [String] :api_secret - the Constant Contact secret key
    # @return
    def initialize(api_secret = nil)
      @client_secret = api_secret || Util::Config.get('auth.api_secret')
      if @client_secret.nil? || @client_secret == ''
        raise ArgumentError.new(Util::Config.get('errors.api_secret_missing'))
      end
    end


    # Get the BillingChangeNotification model object (has url and event_type as properties)
    # Validates and parses the received data into a BillingChangeNotification model
    # @param [String] hmac The value in the x-ctct-hmac-sha256 header.
    # @param [String] data The body message from the POST received from ConstantContact in Webhook callback.
    # @return [BillingChangeNotification] object corresponding to data in case of success
    def get_billing_change_notification(hmac, data)
      if is_valid_webhook(hmac, data)
        Webhooks::Models::BillingChangeNotification.create(JSON.parse(data))
      else
        raise Exceptions::WebhooksException, Util::Config.get('errors.invalid_webhook')
      end
    end


    # Validates a Webhook encrypted message
    # @param [String] hmac The value in the x-ctct-hmac-sha256 header.
    # @param [String] data The body message from the POST received from ConstantContact in Webhook callback.
    # @return true in case of success; false if the Webhook is invalid.
    def is_valid_webhook(hmac, data)
      Webhooks::Helpers::Validator.validate(@client_secret, hmac, data)
    end

  end
end
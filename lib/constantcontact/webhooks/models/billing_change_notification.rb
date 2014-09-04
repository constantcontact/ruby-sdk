#
# billing_change_notification.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Webhooks
    module Models
      class BillingChangeNotification
        attr_accessor :event_type, :url

        # Factory method to create a BillingChangeNotification model object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [BillingChangeNotification]
        def self.create(props)
          obj = BillingChangeNotification.new
          props.each do |key, value|
            key = key.to_s
            obj.send("#{key}=", value) if obj.respond_to? key
          end if props
          obj
        end
      end
    end
  end
end
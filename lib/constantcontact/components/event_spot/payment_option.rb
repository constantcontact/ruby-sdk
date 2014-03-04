#
# payment_option.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class PaymentOption < Component
        attr_accessor :payment_types

        # Factory method to create an event PaymentOption object from a hash
        # @param [Hash] props - properties to create object from
        # @return [PaymentOption]
        def self.create(props)
          obj = PaymentOption.new
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
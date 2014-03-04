#
# payment_address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class PaymentAddress < Component
        attr_accessor :city, :country, :country_code, :latitude, :line1, :line2, :line3, :longitude, :postal_code,
                      :state, :state_code

        # Factory method to create a PaymentAddress object from a json string
        # @param [Hash] props - properties to create object from
        # @return [PaymentAddress]
        def self.create(props)
          obj = PaymentAddress.new
          if props
            props.each do |key, value|
              obj.send("#{key}=", value) if obj.respond_to? key
            end
          end
          obj
        end
      end
    end
  end
end

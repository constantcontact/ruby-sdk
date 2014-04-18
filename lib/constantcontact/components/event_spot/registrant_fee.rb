#
# registrant_fee.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class RegistrantFee < Component
        attr_accessor :id, :amount, :promo_type, :fee_period_type, :type, :name, :quantity

        # Factory method to create a RegistrantFee object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [RegistrantFee]
        def self.create(props)
          obj = RegistrantFee.new
          if props
            props.each do |key, value|
              key = key.to_s
              obj.send("#{key}=", value) if obj.respond_to? key
            end
          end
          obj
        end
      end
    end
  end
end
#
# registrant_promo_code.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class RegistrantPromoCode < Component
        attr_accessor :total_discount, :promo_code_info

        # Factory method to create a RegistrantPromoCode object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [RegistrantPromoCode]
        def self.create(props)
          obj = RegistrantPromoCode.new
          props.each do |key, value|
            key = key.to_s
            if key == 'promo_code_info'
              obj.send("#{key}=", Components::EventSpot::RegistrantPromoCodeInfo.create(value))
            else
              obj.send("#{key}=", value) if obj.respond_to? key
            end
          end if props
          obj
        end
      end
    end
  end
end
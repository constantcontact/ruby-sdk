#
# registrant_promo_code_info.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class RegistrantPromoCodeInfo < Component
        attr_accessor :code_name, :code_type, :discount_amount, :discount_scope, :discount_type, :redemption_count

        # Factory method to create a RegistrantPromoCode object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [RegistrantPromoCodeInfo]
        def self.create(props)
          obj = RegistrantPromoCodeInfo.new
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
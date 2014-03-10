#
# payment_summary.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class PaymentSummary < Component
        attr_accessor :order, :payment_status, :payment_type, :promo_code

        # Factory method to create an event PaymentSummary object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [PaymentSummary]
        def self.create(props)
          obj = PaymentSummary.new
          props.each do |key, value|
            key = key.to_s
            if key == 'order'
              obj.order = Components::EventSpot::RegistrantOrder.create(value)
            elsif key == 'promo_code'
              obj.promo_code = Components::EventSpot::RegistrantPromoCode.create(value)
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
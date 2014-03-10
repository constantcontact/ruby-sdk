#
# registrant_order.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class RegistrantOrder < Component
        attr_accessor :currency_type, :fees, :items, :order_id, :order_date, :total

        # Factory method to create a RegistrantOrder object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [RegistrantOrder]
        def self.create(props)
          obj = RegistrantOrder.new
          props.each do |key, value|
            key = key.to_s
            if key == 'fees'
              value ||= []
              obj.fees = value.collect do |fee|
                Components::EventSpot::RegistrantFee.create(fee)
              end
            elsif key == 'items'
              value ||= []
              obj.items = value.collect do |item|
                Components::EventSpot::SaleItem.create(item)
              end
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
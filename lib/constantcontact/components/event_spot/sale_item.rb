#
# sale_item.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class SaleItem < Component
        attr_accessor :id, :amount, :promo_type, :fee_period_type, :type, :name, :quantity

        # Factory method to create a SaleItem object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [SaleItem]
        def self.create(props)
          obj = SaleItem.new
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
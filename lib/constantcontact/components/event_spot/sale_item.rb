#
# sale_item.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class SaleItem < Component
      attr_accessor :id, :amount, :promo_type, :fee_period_type, :type, :name, :quantity

      # Factory method to create an event Fee object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        item = SaleItem.new
        if props
          props.each do |key, value|
            key = key.to_s
            item.send("#{key}=", value) if item.respond_to? key
          end
        end
        item
      end
    end
  end
end
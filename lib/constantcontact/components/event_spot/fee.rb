#
# fee.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Fee < Component
      attr_accessor :id, :fee, :late_fee, :early_fee, :fee_scope, :label

      # Factory method to create an event Fee object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [Campaign]
      def self.create(props)
        fee = Fee.new
        if props
          props.each do |key, value|
            key = key.to_s
            fee.send("#{key}=", value) if fee.respond_to? key
          end
        end
        fee
      end
    end
  end
end
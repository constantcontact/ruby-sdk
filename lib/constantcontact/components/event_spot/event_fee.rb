#
# event_fee.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class EventFee < Component
      attr_accessor :early_fee, :fee, :fee_scope, :id, :label, :late_fee

      # Factory method to create an event Fee object from a hash
      # @param [Hash] props - hash of properties to create object from
      # @return [EventFee]
      def self.create(props)
        obj = EventFee.new
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
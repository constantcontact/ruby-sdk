#
# event_item_attribute.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class EventItemAttribute < Component
      attr_accessor :id, :name, :quantity_available, :quantity_total

      # Factory method to create an EventItemAttribute object from a hash
      # @param [Hash] props - properties to create object from
      # @return [EventItemAttribute]
      def self.create(props)
        obj = EventItemAttribute.new
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
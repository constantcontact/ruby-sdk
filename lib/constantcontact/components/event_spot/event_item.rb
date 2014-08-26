#
# event_item.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class EventItem < Component
      attr_accessor :attributes, :default_quantity_available, :default_quantity_total, :description,
                    :id, :name, :per_registrant_limit, :price, :show_quantity_available

      # Factory method to create an EventItem object from a hash
      # @param [Hash] props - properties to create object from
      # @return [EventItem]
      def self.create(props)
        obj = EventItem.new
        if props
          props.each do |key, value|
            if key == 'attributes'
              if value
                obj.attributes = []
                value.each do |attribute|
                  obj.attributes << Components::EventItemAttribute.create(attribute)
                end
              end
            else
              obj.send("#{key}=", value) if obj.respond_to? key
            end
          end
        end
        obj
      end
    end
  end
end
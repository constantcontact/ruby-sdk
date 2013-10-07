#
# notification_option.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class NotificationOption < Component
        attr_accessor :notification_type, :is_opted_in

        # Factory method to create an event NotificationOption object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Campaign]
        def self.create(props)
          obj = NotificationOption.new
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
#
# guest.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class Guest < Component
        attr_accessor :guest_id, :guest_section

        # Factory method to create a Guest object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Guest]
        def self.create(props)
          obj = Guest.new
          props.each do |key, value|
            key = key.to_s
            if key == 'guest_section'
              obj.send("#{key}=", Components::EventSpot::GuestSection.create(value))
            else
              obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
            end
          end
          obj
        end
      end
    end
  end
end
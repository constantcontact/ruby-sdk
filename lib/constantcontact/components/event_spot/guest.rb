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

        # Factory method to create an event Registrant object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Campaign]
        def self.create(props)
          guest = Guest.new
          props.each do |key, value|
            key = key.to_s
            if key == 'guest_section'
              guest.send("#{key}=", Components::EventSpot::RegistrantSection.create(value))
            else
              guest.send("#{key}=", value) if guest.respond_to?("#{key}=")
            end
          end
          guest
        end
      end
    end
  end
end
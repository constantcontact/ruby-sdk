#
# guest_section.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class GuestSection < Component
        attr_accessor :label, :fields

        # Factory method to create a GuestSection object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [GuestSection]
        def self.create(props)
          obj = GuestSection.new
          props.each do |key, value|
            key = key.to_s
            if key == 'fields'
              value ||= []
              obj.fields = value.collect do |field|
                Components::EventSpot::RegistrantField.create(field)
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
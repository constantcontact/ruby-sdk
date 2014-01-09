#
# registrant_section.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class RegistrantSection < Component
        attr_accessor :label, :fields

        # Factory method to create an event RegistrantSection object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Campaign]
        def self.create(props)
          section = RegistrantSection.new
          props.each do |key, value|
            key = key.to_s
            if key == 'fields'
              value ||= []
              section.fields = value.collect do |field|
                Components::EventSpot::RegistrantField.create(field)
              end
            else
              section.send("#{key}=", value) if section.respond_to? key
            end
          end if props
          section
        end
      end
    end
  end
end
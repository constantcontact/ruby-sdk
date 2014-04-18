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

        # Factory method to create a RegistrantSection object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [RegistrantSection]
        def self.create(props)
          obj = RegistrantSection.new
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
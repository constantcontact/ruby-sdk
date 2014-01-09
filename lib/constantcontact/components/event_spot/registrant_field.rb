#
# registrant_field.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class RegistrantField < Component
        attr_accessor :type, :name, :label, :value, :values

        # Factory method to create an event Fee object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Campaign]
        def self.create(props)
          field = RegistrantField.new
          props.each do |key, value|
            key = key.to_s
            field.send("#{key}=", value) if field.respond_to? key
          end if props
          field
        end
      end
    end
  end
end
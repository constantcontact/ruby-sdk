#
# address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Address < Component
      attr_accessor :id, :line1, :line2, :line3, :city, :address_type, :state_code,
                    :country_code, :postal_code, :sub_postal_code

      # Factory method to create an Address object from a json string
      # @param [Hash] props - properties to create object from
      # @return [Address]
      def self.create(props)
        obj = Address.new
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

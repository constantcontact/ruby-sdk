#
# account_address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class AccountAddress < Component
      attr_accessor :city, :country_code, :line1, :postal_code, :state_code

      # Factory method to create an AccountAddress object from a json string
      # @param [Hash] props - properties to create object from
      # @return [AccountAddress]
      def self.create(props)
        obj = AccountAddress.new
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

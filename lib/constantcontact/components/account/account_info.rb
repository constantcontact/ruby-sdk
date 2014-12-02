#
# account_info.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class AccountInfo < Component
      attr_accessor :website, :organization_name, :first_name, :last_name, :email, :phone, :country_code, :state_code

      # Class constructor
      # @return [AccountInfo]
      def initialize
      end

      # Factory method to create an AccountInfo object from a json string
      # @param [Hash] props - properties to create object from
      # @return [AccountInfo]
      def self.create(props)
        obj = AccountInfo.new
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

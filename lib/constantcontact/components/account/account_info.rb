#
# account_info.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class AccountInfo < Component
      attr_accessor :website, :organization_name, :first_name, :last_name, :email, :phone, :country_code, :state_code,
                    :company_logo, :time_zone, :organization_addresses

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
            key = key.to_s
            if key == 'organization_addresses'
              value = value || []
              obj.organization_addresses = value.collect{|address| Components::AccountAddress.create(address) }
            else
              obj.send("#{key}=", value) if obj.respond_to? key
            end
          end
        end
        obj
      end
    end
  end
end

#
# email_address.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class EmailAddress < Component
      attr_accessor :id, :status, :confirm_status, :opt_in_source, :opt_in_date, :opt_out_date, :email_address

      # Class constructor
      # @param [String] email_address
      # @return [EmailAddress]
      def initialize(email_address = nil)
        @email_address = email_address if email_address
      end

      # Factory method to create an EmailAddress object from a json string
      # @param [Hash] props - array of properties to create object from
      # @return [EmailAddress]
      def self.create(props)
        email_address = EmailAddress.new
        if props
          props.each do |key, value|
            email_address.send("#{key}=", value)
          end
        end
        email_address
      end

    end
  end
end
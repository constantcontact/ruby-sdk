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
      # @param [Hash] props - properties to create object from
      # @return [EmailAddress]
      def self.create(props)
        obj = EmailAddress.new
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
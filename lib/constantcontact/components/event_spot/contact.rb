#
# contact.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    module EventSpot
      class Contact < Component
        attr_accessor :id, :name, :email_address, :phone_number, :organization_name

        # Factory method to create an event Fee object from a hash
        # @param [Hash] props - hash of properties to create object from
        # @return [Campaign]
        def self.create(props)
          contact = Contact.new
          props.each do |key, value|
            key = key.to_s
            contact.send("#{key}=", value) if contact.respond_to? key
          end if props
          contact
        end
      end
    end
  end
end
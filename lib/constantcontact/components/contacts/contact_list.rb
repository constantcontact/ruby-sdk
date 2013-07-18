#
# contact_list.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ContactList < Component
      attr_accessor :id, :name, :status, :created_date, :modified_date, :contact_count

      # Factory method to create a ContactList object from a json string
      # @param [Hash] props - array of properties to create object from
      # @return [ContactList]
      def self.create(props)
        contact_list = ContactList.new
        if props
          props.each do |key, value|
            contact_list.send("#{key}=", value)
          end
        end
        contact_list
      end

    end
  end
end
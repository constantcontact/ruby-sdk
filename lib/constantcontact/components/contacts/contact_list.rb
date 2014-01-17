#
# contact_list.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ContactList < Component
      attr_accessor :id, :name, :status, :contact_count

      # Factory method to create a ContactList object from a json string
      # @param [Hash] props - properties to create object from
      # @return [ContactList]
      def self.create(props)
        obj = ContactList.new
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
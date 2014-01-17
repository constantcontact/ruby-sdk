#
# message_footer.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class MessageFooter < Component
      attr_accessor :city, :state, :country, :organization_name, :address_line_1,
                    :address_line_2, :address_line_3, :international_state,
                    :postal_code, :include_forward_email, :forward_email_link_text,
                    :include_subscribe_link, :subscribe_link_text

      # Factory method to create a MessageFooter object from an array
      # @param [Hash] props - properties to create object from
      # @return [MessageFooter]
      def self.create(props)
        obj = MessageFooter.new
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
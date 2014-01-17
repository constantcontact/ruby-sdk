#
# forward_activity.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ForwardActivity < Component
      attr_accessor :activity_type, :campaign_id, :contact_id, :email_address, :forward_date

      # Factory method to create a ForwardActivity object from an array
      # @param [Hash] props - properties to create object from
      # @return [ForwardActivity]
      def self.create(props)
        obj = ForwardActivity.new
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
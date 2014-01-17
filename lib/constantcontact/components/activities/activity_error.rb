#
# activity_error.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ActivityError < Component
      attr_accessor :message, :line_number, :email_address

      # Factory method to create an ActivityError object from an array
      # @param [Hash] props - hash of properties to create object from
      # @return [ActivityError]
      def self.create(props)
        obj = ActivityError.new
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
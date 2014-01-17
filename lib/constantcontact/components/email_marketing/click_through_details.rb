#
# click_through_details.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ClickThroughDetails < Component
      attr_accessor :url, :url_uid, :click_count


      # Factory method to create an ClickThroughDetails object from an array
      # @param [Hash] props - properties to create object from
      # @return [ClickThroughDetails]
      def self.create(props)
        obj = ClickThroughDetails.new
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